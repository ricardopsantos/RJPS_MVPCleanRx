//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol Sample_TableViewCellProtocol : GenericTableViewCell_Protocol {
    var rxBehaviorRelay_title: BehaviorRelay<String>   { get set }
    var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    var rxBehaviorRelay_textColor: BehaviorRelay<UIColor>  { get set }
}

extension AppView {
    
    class Sample_TableViewCell: UITableViewCell, GenericTableViewCell_Protocol {
        deinit {
            AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        // BehaviorRelay model a State
        var rxBehaviorRelay_title     = BehaviorRelay<String>(value: "")
        var rxBehaviorRelay_image     = BehaviorRelay<UIImage?>(value: nil) 
        var rxBehaviorRelay_textColor = BehaviorRelay<UIColor>(value: AppColors.lblTextColor)

        class func cellSize() -> CGFloat { return 60 }
        static func prepare(tableView:UITableView) -> Void {
            tableView.register(classForCoder(), forCellReuseIdentifier: reuseIdentifier)
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            if let lbl = textLabel {
                rxBehaviorRelay_title.asDriver().drive(lbl.rx.text).disposed(by: _disposeBag)
                rxBehaviorRelay_textColor.asObservable().subscribe(onNext: { lbl.textColor = $0 }).disposed(by: _disposeBag)
            }
            
            if let img = imageView {
                rxBehaviorRelay_image.asDriver()
                    .do(onNext: { _ in self.setNeedsLayout() })
                    .drive(img.rx.image)
                    .disposed(by: _disposeBag)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
            
        private var _marginH: CGFloat { return 10 }
        private var _marginV: CGFloat { return _marginH }
        private var _imageSize: CGFloat { return V.Sample_TableViewCell.cellSize() - 2 * _marginV }
        private let _disposeBag: DisposeBag = DisposeBag()
        
        private lazy var _lblTitle: UILabel = {
            let some = AppFactory.UIKit.label(baseView: self, style: .value)
            some.rjsALayouts.setMargin(_marginH, on: .left)
            some.rjsALayouts.setMargin(_marginH*2+_imageSize, on: .right)
            some.rjsALayouts.setMargin(_marginV, on: .top)
            some.rjsALayouts.setMargin(_marginV, on: .bottom)
            return some
        }()
        
        private lazy var _image: UIImageView = {
            let some = AppFactory.UIKit.imageView(baseView: self)
            some.rjsALayouts.setMargin(_marginH, on: .right)
            some.rjsALayouts.setMargin(_marginV, on: .top)
            some.rjsALayouts.setSize(CGSize(width: _imageSize, height: _imageSize))
            some.layer.cornerRadius = _imageSize * 0.1
            some.clipsToBounds      = true
            return some
        }()
        
        override func prepareForReuse() {
            super.prepareForReuse()
            set(image: nil)
        }
        
        override func setNeedsLayout() {
            super.setNeedsLayout()
        }
    }
}

//
// Public stuff
//

extension V.Sample_TableViewCell {

}

//
// Protocol
//

extension V.Sample_TableViewCell: Sample_TableViewCellProtocol {
    func set(title: String)      { rxBehaviorRelay_title.accept(title) }
    func set(textColor: UIColor) { rxBehaviorRelay_textColor.accept(textColor) }
    func set(image: UIImage?)     { rxBehaviorRelay_image.accept(image)  }
}
