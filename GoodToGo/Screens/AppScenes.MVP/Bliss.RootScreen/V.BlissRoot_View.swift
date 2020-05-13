//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

extension V {
    class BlissRoot_View: BaseViewControllerMVP {
        
        deinit {
            //AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: BlissRoot_PresenterProtocol!
        
        private var _imageSize: CGFloat = 200
        private var _imgConstraintHeigth: NSLayoutConstraint?
        private lazy var _imageView: UIImageView = {
            let some = UIImageView()
            self.view.addSubview(some)
            some.alpha = 0
            some.layer.cornerRadius = 8.0
            some.clipsToBounds      = true
            some.rjsALayouts.setSame(.centerX, as: self.view)
            some.rjsALayouts.setSame(.centerY, as: self.view)
            some.rjsALayouts.setWidth(_imageSize)
            _imgConstraintHeigth = some.rjsALayouts.setHeight(_imageSize, method: .constraints)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            presenter.generic?.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewWillAppear()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewDidAppear()
        }
        
        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            _imageView.lazyLoad()
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }
    }
}

// MARK: - View Protocol

extension V.BlissRoot_View: BlissRoot_ViewProtocol {
    
    func set(image: UIImage?) {
        guard let image = image else {
            _imageView.fadeTo(0)
            return
        }
        
        let ratio = image.size.width / image.size.height
        let imgCurrentWidh = _imageSize
        let newHeigth = imgCurrentWidh / ratio
        _imageView.image = image
        _imageView.fadeTo(1)
        _imageView.rjsALayouts.updateConstraint(_imgConstraintHeigth!,
                                                toValue: newHeigth,
                                                duration: 0.3,
                                                completion: { (_) in
                                                    
        })
    }
    
    func viewNeedsToDisplayBadServerMessage() {
        let alert = UIAlertController(title: "", message: Messages.Bliss.serverDown, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Messages.ok.localised, style: .default, handler: { [weak self] _ in
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
            self.presenter.userDidReadBadServerHealthMessage()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
