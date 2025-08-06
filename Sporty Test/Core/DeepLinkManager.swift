import UIKit

final class DeepLinkManager: DeepLinkProtocol {
    
    private weak var rootViewController: UIViewController?
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }
    
    //DeepLinkProtocol
    func canOpenURL(_ url: URL) -> Bool {
        
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        print(parameters)
        return url.absoluteString.contains("sporty://")
    }
    
    func openURL(_ url: URL) {
        guard canOpenURL(url) else {
            return
        }
        if let viewController = rootViewController as? RepositoriesViewController{
            viewController.receivedDeepLink(url.absoluteString)
        }
        
    }
}

