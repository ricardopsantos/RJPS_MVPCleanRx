//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UIView {
    
    public var width: CGFloat { return self.frame.width }
    public var height: CGFloat { return self.frame.height }
    
    public func allSubviews<T: UIView>() -> [T] { return UIView.allSubviews(view: self) as [T] }
    public static func allSubviews<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = allSubviews(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }
    
    public func disableUserInteractionFor(_ seconds: Double, disableAlpha: CGFloat=1) {
        guard self.isUserInteractionEnabled else { return }
        guard seconds > 0 else { return }
        self.isUserInteractionEnabled = false
        self.alpha = disableAlpha
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(seconds)) { [weak self] in
            self?.isUserInteractionEnabled = true
            self?.alpha = 1
        }
    }
    
    public func removeAllSubviews() {
        let allViews = self.allSubviews() as [UIView]
        _ = allViews.map { (some) -> Void in
            some.removeFromSuperview()
        }
    }
    
}

extension RJSLibExtension where Target == UIView {
    public func destroy() {
        self.target.removeAllSubviews()
        self.target.removeFromSuperview()
    }
}

///////////// UTILS DEV /////////////

extension RJSLibExtension where Target == UIView {
    public func startActivityIndicator() { RJS_Designables_ActivityIndicator.shared.showProgressView(view: self.target) }
    public func stopActivityIndicator() { RJS_Designables_ActivityIndicator.shared.hideProgressView() }
}
