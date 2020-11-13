//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    
    func setTitleForAllStates(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .selected)
    }
    
    func setTextColorForAllStates(_ color: UIColor) {
        self.titleLabel?.textColor = color
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .selected)
    }
    
    private class ClosureSleeve {
        let block: () -> Void
        init (_ block: @escaping () -> Void) { self.block = block }
        @objc func invoke () { block() }
    }
    
    func onTouchUpInside(autoDisableUserInteractionFor: Double=RJS_Constants.defaultDisableTimeAfterTap, block:@escaping () -> Void) {
        self.disableUserInteractionFor(autoDisableUserInteractionFor)
        let sleeve = ClosureSleeve(block)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: .touchUpInside)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func bumpAndPerform(scale: CGFloat=1.05,
                        disableUserInteractionFor: Double=RJS_Constants.defaultDisableTimeAfterTap,
                        block:@escaping () -> Void) {
        self.disableUserInteractionFor(disableUserInteractionFor)
        UIView.animate(withDuration: RJS_Constants.defaultAnimationsTime/2.0, animations: { [weak self] in
            guard let strongSelf = self else { RJS_Logs.warning(RJS_Constants.referenceLost); return }
            strongSelf.transform = CGAffineTransform(scaleX: scale, y: scale) },
                       completion: { _ in
                        UIView.animate(withDuration: RJS_Constants.defaultAnimationsTime/2.0 ,
                                       animations: { self.transform = .identity },
                                       completion: { _ in
                                        block()
                        })
                        
        })
    }
    
}
