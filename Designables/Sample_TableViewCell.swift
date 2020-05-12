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

public protocol Sample_TableViewCellProtocol: GenericTableViewCell_Protocol {
    var rxBehaviorRelay_title: BehaviorRelay<String> { get set }
    var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    var rxBehaviorRelay_textColor: BehaviorRelay<UIColor> { get set }
}

//public extension V {

open class Sample_TableViewCell: UITableViewCell, GenericTableViewCell_Protocol {
    deinit {
        //AppLogger.log("\(self.className) was killed")
        NotificationCenter.default.removeObserver(self)
    }
    
    // BehaviorRelay model a State
    public var rxBehaviorRelay_title     = BehaviorRelay<String>(value: "")
    public var rxBehaviorRelay_image     = BehaviorRelay<UIImage?>(value: nil)
    public var rxBehaviorRelay_textColor = BehaviorRelay<UIColor>(value: UIColor.App.lblTextColor)

    open class var cellSize: CGFloat { return Designables.Sizes.TableViewCell.defaultSize }
    public static func prepare(tableView: UITableView) {
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var _marginH: CGFloat { return 10 }
    private var _marginV: CGFloat { return _marginH }
    private var _imageSize: CGFloat { return Sample_TableViewCell.cellSize - 2 * _marginV }
    private let _disposeBag: DisposeBag = DisposeBag()
    
    private lazy var _lblTitle: UILabel = {
        let some = UIKitFactory.label(baseView: self, style: .value)
        some.rjsALayouts.setMargin(_marginH, on: .left)
        some.rjsALayouts.setMargin(_marginH*2+_imageSize, on: .right)
        some.rjsALayouts.setMargin(_marginV, on: .top)
        some.rjsALayouts.setMargin(_marginV, on: .bottom)
        return some
    }()
    
    private lazy var _image: UIImageView = {
        let some = UIKitFactory.imageView(baseView: self)
        some.rjsALayouts.setMargin(_marginH, on: .right)
        some.rjsALayouts.setMargin(_marginV, on: .top)
        some.rjsALayouts.setSize(CGSize(width: _imageSize, height: _imageSize))
        some.layer.cornerRadius = _imageSize * 0.1
        some.clipsToBounds      = true
        return some
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        set(image: nil)
    }
    
    public override func setNeedsLayout() {
        super.setNeedsLayout()
    }
}

//
// Public stuff
//

extension Sample_TableViewCell {
    
}

//
// Protocol
//

extension Sample_TableViewCell: Sample_TableViewCellProtocol {
    public func set(title: String) { rxBehaviorRelay_title.accept(title) }
    public func set(textColor: UIColor) { rxBehaviorRelay_textColor.accept(textColor) }
    public func set(image: UIImage?) { rxBehaviorRelay_image.accept(image)  }
}
