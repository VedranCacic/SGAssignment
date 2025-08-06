import Combine
import GitHubAPI
import MockLiveServer
import SwiftUI


/// A view controller that displays a list of GitHub repositories for the "swiftlang" organization.
final class RepositoriesViewController: UITableViewController {
    private let gitHubAPI: GitHubAPI
    private let mockLiveServer: MockLiveServer
    private var repositories: [GitHubMinimalRepository] = []
    
    //pull to refresh control
    private let pullControl:UIRefreshControl = {
        
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
        
        return control
    }()
    
    private var refreshControlActive = false
    
    private var repositoryType:RepositoryType? = nil
    
    init(gitHubAPI: GitHubAPI, mockLiveServer: MockLiveServer) {
        self.gitHubAPI = gitHubAPI
        self.mockLiveServer = mockLiveServer
        
        super.init(style: .insetGrouped)
        
        title = UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryName) as? String
        
        if let stringValue = UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryType) as? String{
            self.repositoryType = RepositoryType(rawValue: stringValue)
        }
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCellIdentifiers.repositoriesTableView)
        
        pullControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        
        tableView.addSubview(pullControl)
        
        //navigation control that goes to networking and data options
        let image = UIImage(systemName: "gearshape.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let buttonItem = UIBarButtonItem.init(image: image, style:.plain, target:self, action: #selector(self.onSettings(sender:)))
        self.navigationItem.rightBarButtonItem = buttonItem
        
        Task {
            await loadRepositories()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repository = repositories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.repositoriesTableView, for: indexPath) as! RepositoryTableViewCell
        
        cell.name = repository.name
        cell.descriptionText = repository.description
        cell.starCountText = repository.stargazersCount.formatted()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        let viewController = RepositoryViewController(
            minimalRepository: repository,
            gitHubAPI: gitHubAPI
        )
        show(viewController, sender: self)
    }
    
    private func loadRepositories() async {
        do {
            let api = GitHubAPI()
            let repo = UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryName) as? String
            repositories = try await api.repositoriesForOrganisation(repo!, type: repositoryType!)
            //end pull to refresh animation
            if refreshControlActive{
                refreshControlActive = false
                pullControl.endRefreshing()
                
            }
            // if data set is empty, for what ever reason, show message to user
            if repositories.count == 0 {
                self.tableView.setEmptyMessage(String(localized: "Something went wrong.") + "\n" + String(localized: "We are not able to get data for this user repositories at this moment."))
            } else {
                self.tableView.restore()
            }
            tableView.reloadData()
        } catch {
            print("Error loading repositories: \(error)")
            repositories = []
            self.tableView.setEmptyMessage(String(localized: "Something went wrong.") + "\n" + String(localized: "We are not able to get data for this user repositories at this moment."))
            tableView.reloadData()
            if refreshControlActive{
                refreshControlActive = false
                pullControl.endRefreshing()
            }
        }
    }
    
    @objc func onSettings(sender: UIBarButtonItem) {
        // Going to settings screen
        let viewController = RepositoriesSettingsViewController()
        viewController.delegate = self
        show(viewController, sender: self)
    }
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
        // pull to refresh functionality
        refreshControlActive = true
        Task {
            await loadRepositories()
        }
    }
    
    //handling of deep/universal links
    func receivedDeepLink(_ deepLink: String) {
        // this is just a showcase, specific link should open specific page but for now
        
        self.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
    
}


extension RepositoriesViewController: RepositoriesSettingsViewControllerDelegate{
    
    func newTokenSaved() {
        // should reload data with new authorisation token
    }
    
    func newRepoChosen() {
        // should fetch data for new repository
        let repo = UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryName) as? String
        title = repo
        
        Task {
            await loadRepositories()
        }
    }
    
    
    func newRepoTypeChosen(type: RepositoryType) {
        repositoryType = type
    }
    
}
