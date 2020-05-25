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

let routeToSomeViewControllerD = DeepLinks.RoutingPath.path(vcType: Tests.SomeViewControllerC.self, objectIdentifier: "", style: .regularVC)
let routeToSomeViewControllerC = DeepLinks.RoutingPath.path(vcType: Tests.SomeViewControllerC.self, objectIdentifier: "", style: .regularVC)
let routeToSomeViewControllerB = DeepLinks.RoutingPath.path(vcType: Tests.SomeViewControllerB.self, objectIdentifier: "", style: .regularVC)
let routeToSomeViewControllerA = DeepLinks.RoutingPath.recursivePath(vcType: Tests.SomeViewControllerA.self, objectIdentifier: "", style: .regularVC, next: [routeToSomeViewControllerB, routeToSomeViewControllerC, routeToSomeViewControllerD])

struct DeepLinks {
    indirect enum RoutingPath {
        case recursivePath(vcType: DeepLinkableViewControllerProtocol.Type, objectIdentifier: String, style: VCPresentationStyle, next: [RoutingPath])
        case path(vcType: DeepLinkableViewControllerProtocol.Type, objectIdentifier: String, style: VCPresentationStyle)
        //case recursivePath(path: RoutingPath, next: [RoutingPath])

        var childs: [RoutingPath] {
            switch self {
            case .recursivePath(vcType: _, objectIdentifier: _, style: _, next: let next): return next
            case .path(vcType: _, objectIdentifier: _, style: _):  return []
            }
        }

        var vcType: DeepLinkableViewControllerProtocol.Type {
            switch self {
            case .recursivePath(vcType: let vcType, objectIdentifier: _, style: _, next: _): return vcType
            case .path(vcType: let vcType, objectIdentifier: _, style: _): return vcType
            }
        }

        var objectIdentifier: String {
            switch self {
            case .recursivePath(vcType: _, objectIdentifier: let objectIdentifier, style: _, next: _): return objectIdentifier
            case .path(vcType: _, objectIdentifier: let objectIdentifier, style: _): return objectIdentifier
            }
        }

        var style: VCPresentationStyle {
            switch self {
            case .recursivePath(vcType: _, objectIdentifier: _, style: let style, next: _): return style
            case .path(vcType: _, objectIdentifier: _, style: let style): return style
            }
        }

        var next: RoutingPath? {
            switch self {
            case .recursivePath(vcType: _, objectIdentifier: _, style: _, next: let next1):
                if let first = next1.first {
                    // Use the child's from the beginning of the flow
                    print(self.childs.count)
                    let nextChilds = [] + self.childs.dropFirst()
                    print(nextChilds.count)
                    return RoutingPath.recursivePath(vcType: first.vcType, objectIdentifier: first.objectIdentifier, style: first.style, next: nextChilds)
                }
            default: ()
            }
            return nil
        }
        static func withNotification(_ userInfo: [AnyHashable: Any]) -> RoutingPath? {
            if let data = userInfo["data"] as? [String: Any] {
                if let messageId = data["messageId"] as? String {
                    return routeToSomeViewControllerA
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
                    return routeToSomeViewControllerA
                }
            default:
                DevTools.Log.error("Couldn't found a route for [\(url)] ")
            }
            return nil
        }

        static func withShortcut(_ shortcut: UIApplicationShortcutItem) -> RoutingPath? {
            switch shortcut.type {
            case ShortcutKey.shortCut1.rawValue: return routeToSomeViewControllerA
            case ShortcutKey.shortCut2.rawValue: return routeToSomeViewControllerB
            case ShortcutKey.shortCut3.rawValue: return routeToSomeViewControllerB
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
            print("flow ended!")
            return
        }
        func doReport(_ somePath: DeepLinks.RoutingPath) {
            print("Path: \(somePath.vcType)")
            print("Remaing: \(somePath.childs.count)")
        }
        doReport(path)
        func present(instance: UIViewController) {
            DevTools.topViewController()?.present(instance, animated: true, completion: {
                let next = path.next
                if let some = next {
                    doReport(some)
                }
                self.displayVC(path: next)
            })
        }

        switch path {
        case .recursivePath(vcType: let vcType, objectIdentifier: let objectIdentifier, style: let style, next: let next):
            let instance = vcType.makeInstance(id: objectIdentifier, style: style)
            present(instance: instance as! UIViewController)
        case .path(vcType: let vcType, objectIdentifier: let objectIdentifier, style: let style):
            let instance = vcType.makeInstance(id: objectIdentifier, style: style)
            present(instance: instance as! UIViewController)
        }
    }
}

protocol DeepLinkableViewControllerProtocol {
    static var deepLinkableIdentifier: String { get }
    var objectId: String? { get set }
    func isReadyToRouteNext() -> Bool // When is fully loaded
    static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol
    func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol
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
        static var deepLinkableIdentifier: String { return "\(self.className)" }
        func isReadyToRouteNext() -> Bool { return true }
         #warning("to codable")
        var objectId: String?
        func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol { SomeViewControllerA.makeInstance(id: id, style: style) }
        static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerA(presentationStyle: style)
            some.objectId = id
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setLabel(text: "\(Self.self)")
        }
    }

    class SomeViewControllerB: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        func isReadyToRouteNext() -> Bool { return true }
        static var deepLinkableIdentifier: String { return "\(self.className)" }
        var objectId: String?
        func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol { SomeViewControllerB.makeInstance(id: id, style: style) }
        static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerB(presentationStyle: style)
            some.objectId = id
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setLabel(text: "\(Self.self)")
        }
    }

    class SomeViewControllerC: DeepLinkableViewController, DeepLinkableViewControllerProtocol {
        static var deepLinkableIdentifier: String { return "\(self.className)" }
        func isReadyToRouteNext() -> Bool { return true }
        var objectId: String?
        func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol { SomeViewControllerC.makeInstance(id: id, style: style) }
        static func makeInstance(id: String, style: VCPresentationStyle) -> DeepLinkableViewControllerProtocol {
            let some = SomeViewControllerC(presentationStyle: style)
            some.objectId = id
            return some
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setLabel(text: "\(Self.self)")
        }
    }
}
