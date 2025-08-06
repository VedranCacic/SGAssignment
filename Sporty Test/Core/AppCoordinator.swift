import GitHubAPI
import MockLiveServer
import UIKit

@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private let gitHubAPI: GitHubAPI
    private let mockLiveServer: MockLiveServer
    var deepLinkManager:DeepLinkManager? = nil

    init(window: UIWindow) {
        self.window = window
        
        //potential solution for authoorisation token
//        if let authToken = UserDefaults.standard.value(forKey: Constants.UserDefaults.authorisationToken) as? String {
//            gitHubAPI = GitHubAPI(authorisationToken: authToken)
//        } else {
//            gitHubAPI = GitHubAPI(authorisationToken: nil)
//        }
        
        if UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryName) == nil{
            UserDefaults.standard.setValue(Constants.Repository.baseRepository, forKey: Constants.UserDefaults.repositoryName)
        }
        
        gitHubAPI = GitHubAPI(authorisationToken: nil)
        mockLiveServer = MockLiveServer()
    }

    func start() {
        
        let baseViewController:RepositoriesViewController = RepositoriesViewController(
            gitHubAPI: gitHubAPI,
            mockLiveServer: mockLiveServer
        )
        window.rootViewController = UINavigationController(
            rootViewController:baseViewController
        )
        window.makeKeyAndVisible()
        
        self.deepLinkManager = DeepLinkManager(rootViewController: baseViewController)
    }
}
