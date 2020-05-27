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

// swiftlint:disable rule_Coding

// https://medium.com/@stasost/ios-how-to-open-deep-links-notifications-and-shortcuts-253fb38e1696
// xcrun simctl openurl booted "gtgdeeplink://thisIsTheHost?queryItem1=1&queryItem2=2"

// xcrun simctl openurl booted "gtgdeeplink://goToScreen?name=list"
// xcrun simctl openurl booted "gtgdeeplink://goToScreen?name=details&id=1"

let pushViewControllerA = DeeplinksManager.RoutingPath.path(vcType: Tests.SomeViewControllerA.self, object: nil, style: .modal, animated: true)
let pushViewControllerB = DeeplinksManager.RoutingPath.path(vcType: Tests.SomeViewControllerB.self, object: nil, style: .modal, animated: true)
let pushViewControllerC = DeeplinksManager.RoutingPath.path(vcType: Tests.SomeViewControllerC.self, object: nil, style: .modal, animated: true)
let pushViewControllerD = DeeplinksManager.RoutingPath.path(vcType: Tests.SomeViewControllerD.self, object: nil, style: .navigation, animated: true)
let pushViewControllerE = DeeplinksManager.RoutingPath.path(vcType: Tests.SomeViewControllerE.self, object: nil, style: .navigation, animated: true)

var routeToE: DeeplinksManager.RoutingPath {
    var step = pushViewControllerE
    return step
}

var routeFromB2D: DeeplinksManager.RoutingPath {
    var step = pushViewControllerC
    step = step.add(step: pushViewControllerD)
    return step
}

var routeFromA2D: DeeplinksManager.RoutingPath {
    var step = pushViewControllerA
    step = step.add(step: pushViewControllerB)
    step = step.add(step: routeFromB2D)
    step = step.add(step: routeToE)
    return step
}

struct DeeplinksManager {
    indirect enum RoutingPath {
        case path(vcType: DeepLinkableViewControllerProtocol.Type, object: Codable?, style: VCPresentationStyle, animated: Bool)
        case recursivePath(path: RoutingPath, next: [RoutingPath])

        func add(step: RoutingPath) -> RoutingPath {
            let path = RoutingPath.path(vcType: self.vcType, object: self.object, style: self.style, animated: self.animated)
            return .recursivePath(path: path, next: self.childs + [step])
        }

        var childs: [RoutingPath] {
            switch self {
            case .path(vcType: _, object: _, style: _, animated: _):  return []
            case .recursivePath(path: _, next: let next): return next
            }
        }

        var animated: Bool {
            switch self {
            case .path(vcType: _, object: _, style: _, animated: let animated): return animated
            case .recursivePath(path: let path, next: _): return path.animated
            }
        }

        var vcType: DeepLinkableViewControllerProtocol.Type {
            switch self {
            case .path(vcType: let vcType, object: _, style: _, animated: _): return vcType
            case .recursivePath(path: let path, next: _): return path.vcType
            }
        }

        var object: Codable? {
            switch self {
            case .recursivePath(path: let path, next: _): return path.object
            case .path(vcType: _, object: let object, style: _, animated: _): return object
            }
        }

        var style: VCPresentationStyle {
            switch self {
            case .recursivePath(path: let path, next: _): return path.style
            case .path(vcType: _, object: _, style: let style, animated: _): return style
            }
        }

        var calculateNext: RoutingPath? {
            switch self {
            case .recursivePath(path: _, next: let next):
                if let nextPath = next.first {
                    // Use the child's from the beginning of the flow
                    var nextChilds1 = [] + self.childs.dropFirst()
                    let nextChilds2 = [] + nextPath.childs
                    if nextChilds2.count > 0 {
                        // The next path, have childs too! Add then to current path...
                        nextChilds1.append(contentsOf: nextChilds2)
                    }
                    let basePath = RoutingPath.path(vcType: nextPath.vcType, object: nextPath.object, style: nextPath.style, animated: nextPath.animated)
                    return RoutingPath.recursivePath(path: basePath, next: nextChilds1)
                }
            case .path(vcType: _, object: _, style: _, animated:_ ): ()
            }
            return nil
        }

        static func withNotification(_ userInfo: [AnyHashable: Any]) -> RoutingPath? {
            if let data = userInfo["data"] as? [String: Any] {
                if let messageId = data["messageId"] as? String {
                    return routeFromA2D
                }
            }
            DevTools.Log.error("Couldn't found a route for [\(userInfo)] ")
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
            switch host {
            case "goToScreen":
                if let theId = queryItems["id"] {
                    return routeFromA2D
                }
            default:
                DevTools.Log.error("Couldn't found a route for [\(url)] ")
            }
            return nil
        }

        static func withShortcut(_ shortcut: UIApplicationShortcutItem) -> RoutingPath? {
            switch shortcut.type {
            case ShortcutKey.shortCut1.rawValue: return routeFromA2D
            case ShortcutKey.shortCut2.rawValue: return routeFromA2D
            case ShortcutKey.shortCut3.rawValue: return routeFromA2D
            default: break
            }
            DevTools.Log.error("Couldn't found a route for [\(shortcut)] ")
            return nil
        }
    }

    enum ShortcutKey: String {
        case shortCut1 = "gtg.goodtogo.newListing"
        case shortCut2 = "gtg.goodtogo.activity"
        case shortCut3 = "gtg.goodtogo.messages"
    }
}

// MARK: - Parsers

extension DeeplinksManager {
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
                return DeeplinksManager.RoutingPath.withNotification(userInfo)
            }
        }

        class DeeplinkParser {
            private init() { }
            static let shared = DeeplinkParser()
            func setup() { }
            func parseDeepLink(_ url: URL) -> RoutingPath? {
                return DeeplinksManager.RoutingPath.withDeepLink(url)
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
                DeeplinksManager.RoutingPath.withShortcut(shortcut)
            }
        }
    }

}

class DeepLinkManager {
    fileprivate init() {}
    static var shared = DeepLinkManager()
    private var deeplinkType: DeeplinksManager.RoutingPath? {
        didSet {
            if let deeplinkType = deeplinkType {
                DevTools.Log.message("[deeplinkType] set to [\(deeplinkType)]")
            } else {
                DevTools.Log.message("[deeplinkType] was unset")
            }
        }
    }

    func handleRemoteNotification(_ notification: [AnyHashable: Any]) {
        deeplinkType = DeeplinksManager.Parsers.NotificationParser.shared.handleNotification(notification)
    }

    @discardableResult
    func handleShortcut(item: UIApplicationShortcutItem) -> Bool {
        deeplinkType = DeeplinksManager.Parsers.ShortcutParser.shared.handleShortcut(item)
        return deeplinkType != nil
    }

    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        deeplinkType = DeeplinksManager.Parsers.DeeplinkParser.shared.parseDeepLink(url)
        if deeplinkType == nil {
            DevTools.Log.warning("Fail to handle [\(url)]")
        }
        return deeplinkType != nil
    }

    // check existing deepling and perform action
    func checkDeepLinksToHandle() {
        guard let deeplinkType = deeplinkType else { return } // Nothing to do.
        DeeplinkRouter.shared.proceedToDeeplink(deeplinkType)
        // reset deeplink after handling
        self.deeplinkType = nil
    }
}

private class DeeplinkRouter {

    static let shared = DeeplinkRouter()
    private init() { }

    func proceedToDeeplink(_ path: DeeplinksManager.RoutingPath?) {
        guard let path = path else { return }

        var instance: UIViewController?
        switch path {
        case .recursivePath(path: let path, next: _):
            instance = path.vcType.makeInstance(object: path.object, style: path.style) as! UIViewController
        case .path(vcType: let vcType, object: let object, style: let style, animated: _):
            instance = vcType.makeInstance(object: object, style: style) as! UIViewController
        }
        guard instance != nil else { return }

        func goToNext() {
            DispatchQueue.executeWithDelay(delay: 0.1) { [weak self] in self?.proceedToDeeplink(path.calculateNext) }
        }

        if path.calculateNext?.style == .navigation && DevTools.topViewController()?.navigationController == nil {
            // The next element will be presented as a navigation controller, and current one
            // is not! We need to transform it on navigation controller
            instance = instance?.embeddedInNavigationController()
        }

        if path.style == .modal {
            //instance!.modalPresentationStyle = .overFullScreen
            DevTools.topViewController()?.present(instance!, animated: path.animated, completion: {
                goToNext()
            })
        } else {
            if let navigationController = DevTools.topViewController()?.navigationController {
                navigationController.pushViewController(instance!, animated: path.animated)
                DispatchQueue.executeWithDelay(delay: path.animated ? 0.3 : 0) {
                    goToNext()
                }
            } else {
                DevTools.assert(false)
            }
        }

    }

}

protocol DeepLinkableViewControllerProtocol: class {
    static var deepLinkableIdentifier: String { get }
    var object: Codable? { get set }
    func isReadyToRouteNext() -> Bool // When is fully loaded
    static func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol
    func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol
}

extension DeepLinkableViewControllerProtocol {
    func isReadyToRouteNext() -> Bool { return true }
    static var deepLinkableIdentifier: String { return "\(String(describing: self))" }
}

class DeepLinkableViewController: BaseViewControllerVIP {
    var label: UILabel?
    func setLabel(text: String) {
        if label == nil {
            label = UIKitFactory.label(title: "", style: .value)
            view.addSubview(label!)
            label!.autoLayout.centerInSuperview()
            label!.autoLayout.width(200)
            label!.autoLayout.height(200)
            label!.textAlignment = .center
        }
        label!.text = text
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }
}

struct Tests {

    class SomeViewControllerA: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        var object: Codable?
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            SomeViewControllerA.makeInstance(object: object, style: style)
        }
        static func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerA(presentationStyle: style)
            some.object = object
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             setLabel(text: "\(Self.deepLinkableIdentifier)")
         }
    }

    class SomeViewControllerB: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        var object: Codable?
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            SomeViewControllerB.makeInstance(object: object, style: style)
        }
        static func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerB(presentationStyle: style)
            some.object = object
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             setLabel(text: "\(Self.deepLinkableIdentifier)")
         }
    }

    class SomeViewControllerC: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        var object: Codable?
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            SomeViewControllerC.makeInstance(object: object, style: style)
        }
        static func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerC(presentationStyle: style)
            some.object = object
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             setLabel(text: "\(Self.deepLinkableIdentifier)")
         }
    }

    class SomeViewControllerD: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        var object: Codable?
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            SomeViewControllerC.makeInstance(object: object, style: style)
        }
        static func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerD(presentationStyle: style)
            some.object = object
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             setLabel(text: "\(Self.deepLinkableIdentifier)")
         }
    }

    class SomeViewControllerE: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        var object: Codable?
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            SomeViewControllerC.makeInstance(object: object, style: style)
        }
        static func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerE(presentationStyle: style)
            some.object = object
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             setLabel(text: "\(Self.deepLinkableIdentifier)")
         }
    }
}
