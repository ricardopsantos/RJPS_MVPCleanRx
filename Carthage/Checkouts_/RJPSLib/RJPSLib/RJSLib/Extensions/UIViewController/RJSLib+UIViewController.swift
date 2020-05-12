//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public typealias RJSPresentedController = (UIViewController?, NSError?) -> Void
public typealias RJSLoadedController    = (UIViewController?, NSError?) -> Void

extension UIViewController {
    public var isVisible: Bool { return self.isViewLoaded && ((self.view.window) != nil) }
}

extension RJSLibExtension where Target == UIViewController {
    
    //
    // UTILS
    //
    
    public func showAlert(title: String="Alert", message: String) {
        DispatchQueue.executeInMainTread {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.target.present(alert, animated: true, completion: nil)
        }
    }
    
    public func destroy() {
      self.target.children.forEach({ (some) in
            some.rjs.destroy()
        })
        self.target.willMove(toParent: nil)
        self.target.view.rjs.destroy()
        self.target.removeFromParent()
        NotificationCenter.default.removeObserver(self) // Remove from all notifications being observed

 }
    
    public static func controllerWith(identifier: String, storyboard: String="Main") -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        controller.modalPresentationStyle = .custom
        return controller
    }
    
    //
    // PRESENT VIEW CONTROLLERS ZONE
    //
    
    public static func present(controller: UIViewController,
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
    
    public static func loadViewControllerInContainedView(sender: UIViewController, senderContainedView: UIView, controller: UIViewController, completion: RJSPresentedController) {
        _ = senderContainedView.removeAllSubviews()
        controller.willMove(toParent: sender)
        senderContainedView.addSubview(controller.view)
        sender.addChild(controller)
        controller.didMove(toParent: sender)
        controller.view.frame = senderContainedView.bounds
        completion(controller, nil)
    }
    
    public static func loadViewControllerInContainedView(sender: UIViewController, senderContainedView: UIView, controllerIdentifier: String, storyboard: String="Main", completion: RJSPresentedController) {
        if let controller = UIViewController.rjs.controllerWith(identifier: controllerIdentifier, storyboard: storyboard) {
            UIViewController.rjs.loadViewControllerInContainedView(sender: sender, senderContainedView: senderContainedView, controller: controller) { (controller, error) in
                completion(controller, error)
            }
        } else {
            completion(nil, nil)
        }
    }
}
