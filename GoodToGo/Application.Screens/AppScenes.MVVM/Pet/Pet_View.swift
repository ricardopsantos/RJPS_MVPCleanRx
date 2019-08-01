//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

//
// MARK: - UserTableViewCell
//

extension AppView {

    public class Pet_View: UIView {
        
        let margim : CGFloat = 10
        lazy var imageView: UIImageView = {
            let some = UIImageView()
            self.addSubview(some)
            //some.contentMode = .scaleAspectFit
            some.rjsALayouts.setMargin(margim, on: .top)
            //some.rjsALayouts.setSame(.centerY, as: self)
            some.rjsALayouts.setSame(.centerX, as: self)
            some.rjsALayouts.setSize(CGSize(width: 200, height: 200))
            return some
        }()
        
        lazy var lblName: UILabel = {
            let some = AppFactory.UIKit.label(baseView: self, style: .title)
            some.rjsALayouts.setMargin(margim, on: .top, from:imageView)
            some.rjsALayouts.setMargin(margim, on: .left)
            some.rjsALayouts.setMargin(margim, on: .right)
            some.rjsALayouts.setHeight(margim*3)
            some.textAlignment = .center
            return some
        }()
        
        lazy var lblAge: UILabel = {
            let some = AppFactory.UIKit.label(baseView: self, style: .title)
            some.rjsALayouts.setMargin(margim, on: .top, from:lblName)
            some.rjsALayouts.setMargin(margim, on: .left)
            some.rjsALayouts.setMargin(margim, on: .right)
            some.rjsALayouts.setHeight(margim*3)
            some.textAlignment = .center
            return some
        }()
        
        lazy var lblAdoptionFee: UILabel = {
            let some = AppFactory.UIKit.label(baseView: self, style: .title)
            some.rjsALayouts.setMargin(margim, on: .top, from:lblAge)
            some.rjsALayouts.setMargin(margim, on: .left)
            some.rjsALayouts.setMargin(margim, on: .right)
            some.rjsALayouts.setHeight(margim*3)
            some.textAlignment = .center
            return some
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            prepareLayout()
        }
        
        private func prepareLayout() {
            imageView.lazyLoad()
            lblName.lazyLoad()
            lblAge.lazyLoad()
            lblAdoptionFee.lazyLoad()
            self.backgroundColor = AppColors.appDefaultBackgroundColor
        }
                
        @available(*, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("init?(coder:) is not supported")
        }
    }

}
