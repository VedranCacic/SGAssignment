import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        
        // catching url schemes/deep links while app is not running
        if let url = connectionOptions.userActivities.first?.webpageURL {
           print(url)
        }
        
        let window = UIWindow(windowScene: scene)
        let appCoordinator = AppCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }
    
    // catching url schemes/deep links while app is in background or foreground
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url{
            if let deepLinkManager = appCoordinator?.deepLinkManager{
                deepLinkManager.openURL(url)
            }
        }
    }
    
}
