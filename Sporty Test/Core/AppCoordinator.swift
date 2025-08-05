import GitHubAPI
import MockLiveServer
import UIKit

@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private let gitHubAPI: GitHubAPI
    private let mockLiveServer: MockLiveServer

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
        window.rootViewController = UINavigationController(
            rootViewController: RepositoriesViewController(
                gitHubAPI: gitHubAPI,
                mockLiveServer: mockLiveServer
            )
        )
        window.makeKeyAndVisible()
    }
}
