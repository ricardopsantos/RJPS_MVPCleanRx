//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public typealias RJSPresentedController = (UIViewController?, NSError?) -> Void
public typealias RJSLoadedController    = (UIViewController?, NSError?) -> Void

public extension RJSLibExtension where Target == UIViewController {
    func showAlert(title: String="Alert", message: String) { self.target.showAlert(title: title, message: message) }
    func destroy() { self.target.destroy() }
    func dismissMe() { self.target.dismissMe() }
    func dismissAll() { self.target.dismissAll() }
}

public extension UIViewController {

    static var topViewController: UIViewController {
        return UIApplication.topViewController()!
    }
    var isVisible: Bool { return self.isViewLoaded && ((self.view.window) != nil) }

    func debugStack() {
        if let navigationController = self.navigationController {
            if navigationController.children.count > 0 {
                RJS_Logs.message("Children's : \(navigationController.children.count)")
                RJS_Logs.message("Fist Nav : \(String(describing: navigationController.children.first?.className))")
                var childrensInfo = ""
                navigationController.children.forEach { (some) in
                    childrensInfo += " -\(some.className)\n"
                }
                RJS_Logs.message("Children\n \(childrensInfo)")
            }
        }
    }

    //
    // UTILS
    //

    func embeddedInNavigationController() -> UINavigationController {
        assert(parent == nil, "Cannot embebed in a Navigation Controller. \(String(describing: self)) already has a parent controller.")
        let navController = UINavigationController(rootViewController: self)
        return navController
    }

    func dismissMe() { dismiss(options: 2)}
    func dismissAll() { dismiss(options: 1)}

    /// Param options = 1 : all view controllers
    /// Param options = 2 : self view controller
    func dismiss(options: Int, animated: Bool=true, completion: (() -> Void)? = nil) {
        if options == 1 {
            var presentingVC = presentingViewController
            while presentingVC?.presentingViewController != nil {
                presentingVC = presentingVC?.presentingViewController
            }
            presentingVC?.dismiss(animated: animated, completion: completion)
        } else {
            let navigationController = self.navigationController != nil
            if !navigationController {
                self.dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
        }
    }

    func showAlert(title: String="Alert",
                   message: String) {
        DispatchQueue.executeInMainTread {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func destroy() {
        self.children.forEach({ (some) in
            some.destroy()
        })
        self.willMove(toParent: nil)
        self.view.rjs.destroy()
        self.removeFromParent()
        NotificationCenter.default.removeObserver(self) // Remove from all notifications being observed

    }

    static func controllerWith(identifier: String,
                               storyboard: String="Main") -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        controller.modalPresentationStyle = .custom
        return controller
    }

    //
    // PRESENT VIEW CONTROLLERS ZONE
    //

    static func present(controller: UIViewController,
                        sender: UIViewController,
                        modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
                        loadedController:@escaping RJSLoadedController = { _, _ in },
                        completion:@escaping RJSPresentedController = { _, _ in }) {
        controller.modalTransitionStyle = modalTransitionStyle
        loadedController(controller, nil)
        sender.present(controller, animated: true, completion: {
            completion(controller, nil)
        })

    }

    //
    // LOAD VIEW CONTROLLERS ZONE
    //

    static func loadViewControllerInContainedView(sender: UIViewController,
                                                  senderContainedView: UIView,
                                                  controller: UIViewController,
                                                  completion: RJSPresentedController) {
        senderContainedView.removeAllSubviews()
        controller.willMove(toParent: sender)
        senderContainedView.addSubview(controller.view)
        sender.addChild(controller)
        controller.didMove(toParent: sender)
        controller.view.frame = senderContainedView.bounds
        completion(controller, nil)
    }

    static func loadViewControllerInContainedView(sender: UIViewController,
                                                  senderContainedView: UIView,
                                                  controllerIdentifier: String,
                                                  storyboard: String="Main",
                                                  completion: RJSPresentedController) {
        if let controller = UIViewController.controllerWith(identifier: controllerIdentifier, storyboard: storyboard) {
            UIViewController.loadViewControllerInContainedView(sender: sender, senderContainedView: senderContainedView, controller: controller) { (controller, error) in
                completion(controller, error)
            }
        } else {
            completion(nil, nil)
        }
    }
}
