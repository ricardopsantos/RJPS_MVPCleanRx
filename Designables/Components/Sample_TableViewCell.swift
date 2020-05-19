//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
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
        if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { DevTools.Log.log("\(self.className) was killed") }
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

        rxBehaviorRelay_title
            .asObservable()
            .subscribe(onNext: { [weak self] (some) in
                self?.lblTitle.label.text = some
            }).disposed(by: disposeBag)

        rxBehaviorRelay_textColor
            .asObservable()
            .subscribe(onNext: { [weak self] (some) in
                self?.lblTitle.label.textColor = some
            }).disposed(by: disposeBag)

        rxBehaviorRelay_image
            .asObservable()
            .subscribe(onNext: { [weak self] (some) in
                self?.imgView.image = some
                self?.setNeedsLayout()
            }).disposed(by: disposeBag)

    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var marginH: CGFloat { return 10 }
    private var marginV: CGFloat { return marginH }
    private var imageSize: CGFloat { return Sample_TableViewCell.cellSize - 2 * marginV }
    private let disposeBag: DisposeBag = DisposeBag()
    
    private lazy var lblTitle: UILabelWithPadding = {
        let some = UIKitFactory.labelWithPadding(style: .title)
        self.addSubview(some)
        some.rjsALayouts.setMargin(marginH, on: .left)
        some.rjsALayouts.setMargin(marginH*2+imageSize, on: .right)
        some.rjsALayouts.setMargin(marginV, on: .top)
        some.rjsALayouts.setMargin(marginV, on: .bottom)
        return some
    }()
    
    private lazy var imgView: UIImageView = {
        let some = UIKitFactory.imageView(baseView: self)
        some.rjsALayouts.setMargin(marginH, on: .right)
        some.rjsALayouts.setMargin(marginV, on: .top)
        some.rjsALayouts.setSize(CGSize(width: imageSize, height: imageSize))
        some.layer.cornerRadius = imageSize * 0.1
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
