//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension RJSLibExtension where Target == UIView {
    
    func show() { self.target.isHidden = false }
    func hide() { self.target.isHidden = true }
    var width : CGFloat { get { return self.target.frame.width } }
    var height: CGFloat { get { return self.target.frame.height } }
    
    func allSubviews<T: UIView>() -> [T] { return UIView.rjs.allSubviews(view: self.target) as [T] }
    static func allSubviews<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = allSubviews(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }
    
    func removeAllSubviews() {
        let allViews = self.target.rjs.allSubviews() as [UIView]
        let _ = allViews.map { (some) -> Void in
            some.removeFromSuperview()
        }
    }
    
    func destroy() -> Void {
        removeAllSubviews()
        self.target.removeFromSuperview()
    }
    
}

///////////// UTILS DEV /////////////

extension RJSLibExtension where Target == UIView {
    func startActivityIndicator() { RJSLib.ActivityIndicator.shared.showProgressView(view: self.target) }
    func stopActivityIndicator()  { RJSLib.ActivityIndicator.shared.hideProgressView() }
}



