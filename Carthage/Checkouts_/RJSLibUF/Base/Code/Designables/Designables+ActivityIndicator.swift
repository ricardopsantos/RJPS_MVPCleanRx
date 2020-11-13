//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

public extension RJSLib.Designables {
    
    class ActivityIndicator {
        
        var containerView = UIView()
        var progressView  = UIView()
        var activityIndicator = UIActivityIndicatorView()
        
        public class var shared: ActivityIndicator {
            struct Static {
                static let shared: ActivityIndicator = ActivityIndicator()
            }
            return Static.shared
        }
        
        public func showProgressView(view: UIView) {
            
            if let oldContainerView = view.viewWithTag(RJS_Constants.Tags.progressView) {
                oldContainerView.removeFromSuperview()
            }
            
            containerView.frame             = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            containerView.backgroundColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            progressView.frame              = CGRect(x: 0, y: 0, width: 80, height: 80)
            progressView.center             = containerView.center
            progressView.backgroundColor    = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            progressView.clipsToBounds      = true
            progressView.layer.cornerRadius = 10
            
            activityIndicator.frame  = CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
            activityIndicator.style = .whiteLarge
            
            progressView.addSubview(activityIndicator)
            containerView.addSubview(progressView)
            containerView.tag = RJS_Constants.Tags.progressView
            containerView.alpha = 0
            view.addSubview(containerView)
            
            activityIndicator.startAnimating()
            UIView.animate(withDuration: RJS_Constants.defaultDelay, animations: { [weak self] in
                self?.containerView.alpha = 1
            })
            
        }
        
        public func hideProgressView() {
            UIView.animate(withDuration: RJS_Constants.defaultDelay, animations: { [weak self] in
                self?.containerView.alpha = 0
                }, completion: { (_) in
                    self.activityIndicator.stopAnimating()
                    self.containerView.removeFromSuperview()
            })
        }
    }
}
