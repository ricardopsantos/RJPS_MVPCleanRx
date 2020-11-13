//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

///////////// UTILS DEV /////////////

public extension RJSLibExtension where Target == UIView {
    func startActivityIndicator() { RJS_Designables_ActivityIndicator.shared.showProgressView(view: self.target) }
    func stopActivityIndicator() { RJS_Designables_ActivityIndicator.shared.hideProgressView() }

    var width: CGFloat { return self.target.width }
    var height: CGFloat { return self.target.height }
    func allSubviews<T: UIView>() -> [T] { return self.target.allSubviews() }
    func disableUserInteractionFor(_ seconds: Double, disableAlpha: CGFloat=1) { return self.target.disableUserInteractionFor(seconds, disableAlpha: disableAlpha) }
    func destroy() { self.target.destroy() }
    func removeAllSubviews() { self.target.removeAllSubviews() }

}

public extension UIView {
    
    var width: CGFloat { return self.frame.width }
    var height: CGFloat { return self.frame.height }

    func fadeTo(_ value: CGFloat, duration: Double=RJS_Constants.defaultAnimationsTime) {
        RJS_Utils.executeInMainTread { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.alpha = value
            }
        }
    }

    func allSubviews<T: UIView>() -> [T] { return UIView.allSubviews(view: self) as [T] }
    static func allSubviews<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = allSubviews(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }
    
    func disableUserInteractionFor(_ seconds: Double, disableAlpha: CGFloat=1) {
        guard self.isUserInteractionEnabled else { return }
        guard seconds > 0 else { return }
        self.isUserInteractionEnabled = false
        self.alpha = disableAlpha
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(seconds)) { [weak self] in
            self?.isUserInteractionEnabled = true
            self?.alpha = 1
        }
    }
    
    func removeAllSubviews() {
        let allViews = self.allSubviews() as [UIView]
        _ = allViews.map { (some) -> Void in
            some.removeFromSuperview()
        }
    }

    func destroy() {
        self.removeAllSubviews()
        self.removeFromSuperview()
    }

}
