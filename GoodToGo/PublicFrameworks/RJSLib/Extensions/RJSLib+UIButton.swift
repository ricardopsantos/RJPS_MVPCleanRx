//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLibExtension where Target == UIButton {
    
    func setTitleForAllStates(_ title:String) -> Void {
        self.target.setTitle(title, for: .normal)
        self.target.setTitle(title, for: .selected)
    }
    
    func setTextColorForAllStates(_ color:UIColor) -> Void {
        self.target.titleLabel?.textColor = color
        self.target.setTitleColor(color, for: .normal)
        self.target.setTitleColor(color, for: .selected)
    }
    
    func bumpAndPerformBlock(_ scale:CGFloat=1.05, block:@escaping ()->()) {
        let duration = 0.3
        let finalScale = scale
        if(self.target.isKind(of: UIButton.self)) {
            UIView.animate(withDuration: duration/2.0 , animations: {
                self.target.transform = CGAffineTransform(scaleX: finalScale, y: finalScale) },
                           completion: { finish in
                            UIView.animate(withDuration: duration/2.0 ,
                                           animations: { self.target.transform = CGAffineTransform.identity },
                                           completion: { finish in
                                            block()
                            })
                            
            })
        }
    }
    
}
