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

let pushViewControllerA = DeepLinks.RoutingPath.path(vcType: Tests.SomeViewControllerA.self, object: nil, style: .regularVC)
let pushViewControllerB = DeepLinks.RoutingPath.path(vcType: Tests.SomeViewControllerB.self, object: nil, style: .regularVC)
let pushViewControllerC = DeepLinks.RoutingPath.path(vcType: Tests.SomeViewControllerC.self, object: nil, style: .regularVC)
let pushViewControllerD = DeepLinks.RoutingPath.path(vcType: Tests.SomeViewControllerD.self, object: nil, style: .regularVC)

var testRoute: DeepLinks.RoutingPath {
    var step1 = pushViewControllerA
    step1 = step1.add(step: pushViewControllerB)
    step1 = step1.add(step: pushViewControllerC)
    step1 = step1.add(step: pushViewControllerD)
    return step1
}

struct DeepLinks {
    indirect enum RoutingPath {
        case recursivePath(vcType: DeepLinkableViewControllerProtocol.Type, object: Codable?, style: VCPresentationStyle, next: [RoutingPath])
        case path(vcType: DeepLinkableViewControllerProtocol.Type, object: Codable?, style: VCPresentationStyle)

        func add(step: RoutingPath) -> RoutingPath {
            return .recursivePath(vcType: self.vcType, object: self.object, style: self.style, next: self.childs + [step])
        }

        var childs: [RoutingPath] {
            switch self {
            case .recursivePath(vcType: _, object: _, style: _, next: let next): return next
            case .path(vcType: _, object: _, style: _):  return []
            }
        }

        var vcType: DeepLinkableViewControllerProtocol.Type {
            switch self {
            case .recursivePath(vcType: let vcType, object: _, style: _, next: _): return vcType
            case .path(vcType: let vcType, object: _, style: _): return vcType
            }
        }

        var object: Codable? {
            switch self {
            case .recursivePath(vcType: _, object: let object, style: _, next: _): return object
            case .path(vcType: _, object: let object, style: _): return object
            }
        }

        var style: VCPresentationStyle {
            switch self {
            case .recursivePath(vcType: _, object: _, style: let style, next: _): return style
            case .path(vcType: _, object: _, style: let style): return style
            }
        }

        var calculateNext: RoutingPath? {
            switch self {
            case .recursivePath(vcType: _, object: _, style: _, next: let next1):
                if let first = next1.first {
                    // Use the child's from the beginning of the flow
                    let nextChilds = [] + self.childs.dropFirst()
                   // devia ser os filhos do pais e os actuais
                    return RoutingPath.recursivePath(vcType: first.vcType, object: first.object, style: first.style, next: nextChilds)
                }
            default: ()
            }
            return nil
        }
        static func withNotification(_ userInfo: [AnyHashable: Any]) -> RoutingPath? {
            if let data = userInfo["data"] as? [String: Any] {
                if let messageId = data["messageId"] as? String {
                    return testRoute
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
                    return testRoute
                }
            default:
                DevTools.Log.error("Couldn't found a route for [\(url)] ")
            }
            return nil
        }

        static func withShortcut(_ shortcut: UIApplicationShortcutItem) -> RoutingPath? {
            switch shortcut.type {
            case ShortcutKey.shortCut1.rawValue: return testRoute
            case ShortcutKey.shortCut2.rawValue: return testRoute
            case ShortcutKey.shortCut3.rawValue: return testRoute
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

    func proceedToDeeplink(_ type: DeepLinks.RoutingPath) {
        displayVC(path: type)
    }

    private func displayVC(path: DeepLinks.RoutingPath?) {
        guard let path = path else {
            return
        }

        var instance: UIViewController?
        switch path {
        case .recursivePath(vcType: let vcType, object: let object, style: let style, next: _):
            instance = vcType.makeInstance(object: object, style: style) as! UIViewController
        case .path(vcType: let vcType, object: let object, style: let style):
            instance = vcType.makeInstance(object: object, style: style) as! UIViewController
        }
        guard instance != nil else { return }
        DevTools.topViewController()?.present(instance!, animated: true, completion: {
            DispatchQueue.executeWithDelay(delay: 1) { [weak self] in
                self?.displayVC(path: path.calculateNext)
            }
        })

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
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol { SomeViewControllerA.makeInstance(object: object, style: style) }
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
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol { SomeViewControllerB.makeInstance(object: object, style: style) }
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
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol { SomeViewControllerC.makeInstance(object: object, style: style) }
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
        func makeInstance(object: Codable?, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol { SomeViewControllerC.makeInstance(object: object, style: style) }
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
}
