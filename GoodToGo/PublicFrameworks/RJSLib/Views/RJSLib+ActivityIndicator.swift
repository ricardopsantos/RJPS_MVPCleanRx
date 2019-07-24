//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

extension RJSLib {
    
    class ActivityIndicator {
        
        var containerView = UIView()
        var progressView = UIView()
        var activityIndicator = UIActivityIndicatorView()
        
        class var shared: RJSLib.ActivityIndicator {
            struct Static {
                static let instance: RJSLib.ActivityIndicator = RJSLib.ActivityIndicator()
            }
            return Static.instance
        }
        
        func showProgressView(view: UIView) {
            
            if let oldContainerView = view.viewWithTag(RJSLib.Constants.Tags.progressView) {
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
            containerView.tag = RJSLib.Constants.Tags.progressView
            containerView.alpha = 0
            view.addSubview(containerView)
            
            activityIndicator.startAnimating()
            UIView.animate(withDuration: RJSLib.Constants.defaultDelay, animations: {
                self.containerView.alpha = 1
            })
            
        }
        
        func hideProgressView() {
            UIView.animate(withDuration: RJSLib.Constants.defaultDelay, animations: {
                self.containerView.alpha = 0
            }) { (_) in
                self.activityIndicator.stopAnimating()
                self.containerView.removeFromSuperview()
            }
        }
    }

}

