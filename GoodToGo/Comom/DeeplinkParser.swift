//
//  DeepLinksManager.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 24/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import DevTools
import AppResources

// https://medium.com/@stasost/ios-how-to-open-deep-links-notifications-and-shortcuts-253fb38e1696
// xcrun simctl openurl booted "gtgdeeplink://questions?question_id=1"
struct DeepLinks {
    enum RoutingOptions {
        case viewControllerA
        case viewControllerB(id: String)
        case viewControllerC(ViewControllerCChilds)
        enum ViewControllerCChilds {
            case root
            case viewControllerD(id: String)
        }
        static func withNotification(_ userInfo: [AnyHashable: Any]) -> RoutingOptions? {
            if let data = userInfo["data"] as? [String: Any] {
                if let messageId = data["messageId"] as? String {
                    return RoutingOptions.viewControllerC(.viewControllerD(id: messageId))
                }
            }
            return nil
        }

        static func withDeepLink(_ url: URL) -> RoutingOptions? {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let host = components.host else {
                    return nil
            }
            var pathComponents = components.path.components(separatedBy: "/")
            pathComponents.removeFirst() // the first component is empty
            switch host {
            case "messages": if let messageId = pathComponents.first { return RoutingOptions.viewControllerC(.viewControllerD(id: messageId)) }
            case "request": if let requestId = pathComponents.first { return RoutingOptions.viewControllerB(id: requestId) }
            default: break
            }
            return nil
        }

        static func withShortcut(_ shortcut: UIApplicationShortcutItem) -> RoutingOptions? {
            switch shortcut.type {
            case ShortcutKey.shortCut1.rawValue: return RoutingOptions.viewControllerC(.viewControllerD(id: "1"))
            case ShortcutKey.shortCut2.rawValue: return RoutingOptions.viewControllerA
            case ShortcutKey.shortCut3.rawValue: return RoutingOptions.viewControllerC(.root)
            default: return nil
            }
        }
    }

    enum ShortcutKey: String {
        case shortCut1 = "gtg.goodtogo.newListing"
        case shortCut2 = "gtg.goodtogo.activity"
        case shortCut3 = "gtg.goodtogo.messages"
    }
}

extension DeepLinks {
    struct Parsers {

        class NotificationParser {
            static let shared = NotificationParser()
            private init() { }

            func setup() {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, error) in
                    if let error = error { DevTools.Log.error(error) }
                }
                UIApplication.shared.registerForRemoteNotifications()
            }

            func handleNotification(_ userInfo: [AnyHashable: Any]) -> RoutingOptions? {
                return DeepLinks.RoutingOptions.withNotification(userInfo)
            }
        }

        class DeeplinkParser {
            private init() { }
            static let shared = DeeplinkParser()
            func setup() { }
            func parseDeepLink(_ url: URL) -> RoutingOptions? {
                return DeepLinks.RoutingOptions.withDeepLink(url)
            }
        }

        class ShortcutParser {
            private init() { }
            static let shared = ShortcutParser()

            func setup() {
                let shortcutItem1 = UIApplicationShortcutItem(type: ShortcutKey.shortCut2.rawValue,
                                                                     localizedTitle: Messages.email.localised,
                                                                     localizedSubtitle: nil,
                                                                     icon: UIApplicationShortcutIcon(templateImageName: "icons8-cash-app"),
                                                                     userInfo: nil)

                let shortcutItem2 = UIApplicationShortcutItem(type: ShortcutKey.shortCut3.rawValue,
                                                                    localizedTitle: Messages.welcome.localised,
                                                                    localizedSubtitle: nil,
                                                                    icon: UIApplicationShortcutIcon(templateImageName: "icons8-cash-app"),
                                                                    userInfo: nil)

                let shortcutItem3 = UIApplicationShortcutItem(type: ShortcutKey.shortCut3.rawValue,
                                                                    localizedTitle: Messages.login.localised,
                                                                    localizedSubtitle: nil,
                                                                    icon: UIApplicationShortcutIcon(templateImageName: "icons8-cash-app"),
                                                                    userInfo: nil)

                UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
            }

            func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> RoutingOptions? {
                DeepLinks.RoutingOptions.withShortcut(shortcut)
            }
        }
    }

}

class DeepLinkManager {
    fileprivate init() {}
    static var shared = DeepLinkManager()
    private var deeplinkType: DeepLinks.RoutingOptions? { didSet { DevTools.Log.message("deeplinkType set to [\(deeplinkType!)]") } }

    func handleRemoteNotification(_ notification: [AnyHashable: Any]) {
        deeplinkType = DeepLinks.Parsers.NotificationParser.shared.handleNotification(notification)
    }

    @discardableResult
    func handleShortcut(item: UIApplicationShortcutItem) -> Bool {
        deeplinkType = DeepLinks.Parsers.ShortcutParser.shared.handleShortcut(item)
        return deeplinkType != nil
    }

    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        deeplinkType = DeepLinks.Parsers.DeeplinkParser.shared.parseDeepLink(url)
        return deeplinkType != nil
    }

    // check existing deepling and perform action
    func checkDeepLinksToHandle() {
        guard let deeplinkType = deeplinkType else {
            // Nothing to do.
            return
        }
        DeeplinkRouter.shared.proceedToDeeplink(deeplinkType)
        // reset deeplink after handling
        self.deeplinkType = nil
    }
}

private class DeeplinkRouter {

    static let shared = DeeplinkRouter()
    private init() { }

    var alertController = UIAlertController()

    func proceedToDeeplink(_ type: DeepLinks.RoutingOptions) {
        switch type {
        case .viewControllerA: displayAlert(title: "Activity")
        case .viewControllerC(.root): displayAlert(title: "Messages Root")
        case .viewControllerC(.viewControllerD(id: let id)): displayAlert(title: "Messages Details \(id)")
        case .viewControllerB(id: let id): displayAlert(title: "Request Details \(id)")
        }
    }

    private func displayAlert(title: String) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        alertController.title = title
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            if vc.presentedViewController != nil {
                alertController.dismiss(animated: false, completion: {
                    vc.present(self.alertController, animated: true, completion: nil)
                })
            } else {
                vc.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

class SomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
