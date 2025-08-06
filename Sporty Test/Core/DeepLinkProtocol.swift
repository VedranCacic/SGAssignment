import Foundation

protocol DeepLinkProtocol {
    func canOpenURL(_ url: URL) -> Bool
    func openURL(_ url: URL)
}

