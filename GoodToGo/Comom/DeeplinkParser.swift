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
import Designables
import UIBase

// https://medium.com/@stasost/ios-how-to-open-deep-links-notifications-and-shortcuts-253fb38e1696
// xcrun simctl openurl booted "gtgdeeplink://thisIsTheHost?queryItem1=1&queryItem2=2"

// xcrun simctl openurl booted "gtgdeeplink://goToScreen?name=list"
// xcrun simctl openurl booted "gtgdeeplink://goToScreen?name=details&id=1"

struct DeepLinks {
    indirect enum RoutingPath {
        case path(vc: BaseViewControllerVIP.Type, objectIdentifier: String, style: VCPresentationStyle, next: [RoutingPath])
        case viewControllerA
        case viewControllerB(id: String)
        case viewControllerC(ViewControllerCChilds)
        enum ViewControllerCChilds {
            case root
            case viewControllerD(id: String)
        }
        static func withNotification(_ userInfo: [AnyHashable: Any]) -> RoutingPath? {
            if let data = userInfo["data"] as? [String: Any] {
                if let messageId = data["messageId"] as? String {
                    return RoutingPath.viewControllerC(.viewControllerD(id: messageId))
                }
            }
            DevTools.Log.error("Couldnt found a route for [\(userInfo)] ")
            return nil
        }

        static func withDeepLink(_ url: URL) -> RoutingPath? {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let host = components.host else {
                    return nil
            }

            var queryItems: [String: String] = [:]
            var debug = "\n"
            if !components.path.trim.isEmpty { debug += "# Path      : \(components.path)\n" }
            if components.string != nil {      debug += "# FullLink  : \(components.string!)\n" }
            if components.scheme != nil {      debug += "# Scheme    : \(components.scheme!)\n" }
            if components.host != nil {        debug += "# Host      : \(components.host!)\n" }
            if components.queryItems != nil {  debug += "# QueryItems: \(components.queryItems!)\n" }
            components.queryItems?.forEach({ (some) in
                debug += " - QueryItem [\(some.name)] = [\(some.value!)]\n"
                queryItems[some.name] = some.value!
            })
            DevTools.Log.message("\(debug)")

            //var pathComponents = components.path.components(separatedBy: "?")
            //pathComponents.removeFirst() // the first component is empty
            switch host {
            case "goToScreen": if let theId = queryItems["name"] { return RoutingPath.path(vc: Tests.SomeViewControllerA.self, objectIdentifier: theId, style: .regularVC, next: []) }
            //case "goToScreen": if let theId = queryItems["name"] { return RoutingPath.viewControllerC(.viewControllerD(id: theId)) }
            //case "request": if let requestId = pathComponents.first { return RoutingPath.viewControllerB(id: requestId) }
            default:
                DevTools.Log.error("Couldn't found a route for [\(url)] ")
            }
            return nil
        }

        static func withShortcut(_ shortcut: UIApplicationShortcutItem) -> RoutingPath? {
            switch shortcut.type {
            case ShortcutKey.shortCut1.rawValue: return RoutingPath.viewControllerC(.viewControllerD(id: "1"))
            case ShortcutKey.shortCut2.rawValue: return RoutingPath.viewControllerA
            case ShortcutKey.shortCut3.rawValue: return RoutingPath.viewControllerC(.root)
            default: break
            }
            DevTools.Log.error("Couldnt found a route for [\(shortcut)] ")
            return nil
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

            func handleNotification(_ userInfo: [AnyHashable: Any]) -> RoutingPath? {
                return DeepLinks.RoutingPath.withNotification(userInfo)
            }
        }

        class DeeplinkParser {
            private init() { }
            static let shared = DeeplinkParser()
            func setup() { }
            func parseDeepLink(_ url: URL) -> RoutingPath? {
                return DeepLinks.RoutingPath.withDeepLink(url)
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

            func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> RoutingPath? {
                DeepLinks.RoutingPath.withShortcut(shortcut)
            }
        }
    }

}

class DeepLinkManager {
    fileprivate init() {}
    static var shared = DeepLinkManager()
    private var deeplinkType: DeepLinks.RoutingPath? {
        didSet {
            if let deeplinkType = deeplinkType {
                DevTools.Log.message("deeplinkType set to [\(deeplinkType)]")
            } else {
                DevTools.Log.message("deeplinkType unset")
            }
        }
    }

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
        if deeplinkType == nil {
            DevTools.Log.warning("Fail to handle [\(url)]")
        }
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

    func proceedToDeeplink(_ type: DeepLinks.RoutingPath) {
        switch type {
        case .path(_): displayVC(path: type)
        case .viewControllerA: ()
        case .viewControllerB(_): ()
        case .viewControllerC(_): ()
        }
        DevTools.assert(false, message: "Fail to proceed to DL")
    }

    private func displayVC(path: DeepLinks.RoutingPath) {
        switch path {
        case .path(vc: let vc, objectIdentifier: let objectIdentifier, style: let style, next: let next):
            if let vc = UIApplication.shared.keyWindow?.rootViewController {
                if vc.presentedViewController != nil {
                    let instance = (vc as! DeepLinkableViewControllerProtocol).makeInstance(id: objectIdentifier, style: style)
                    vc.present(instance, animated: true) {
                        
                    }
                } else {
                    vc.present(alertController, animated: true, completion: nil)
                }
            }
        case .viewControllerA: ()
        case .viewControllerB(id: let id): ()
        case .viewControllerC(_): ()
        }
    }
}

protocol DeepLinkableViewControllerProtocol {
    static var deepLinkableIdentifier: String { get }
    var objectId: String? { get set }
    static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol
}

class DeepLinkableViewController: BaseViewControllerVIP {
    let label = UIKitFactory.label(title: "", style: .value)
    func setLabel(text: String) {
        self.view.addSubview(label)
        label.text = title
        label.autoLayout.edgesToSuperview()
    }
}

struct Tests {
    class SomeViewControllerA: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        static var deepLinkableIdentifier: String { return "\(self.className)" }
        var objectId: String?
        static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerA(presentationStyle: style)
            some.objectId = id
            return some
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            setLabel(text: "\(SomeViewControllerA.self)")
        }
    }

    class SomeViewControllerB: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        static var deepLinkableIdentifier: String { return "\(self.className)" }
        var objectId: String?
        static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerB(presentationStyle: style)
            some.objectId = id
            return some
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            setLabel(text: "\(SomeViewControllerA.self)")
        }
    }

    class SomeViewControllerC: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        static var deepLinkableIdentifier: String { return "\(self.className)" }
        var objectId: String?
        static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerC(presentationStyle: style)
            some.objectId = id
            return some
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            setLabel(text: "\(SomeViewControllerA.self)")
        }
    }
}
