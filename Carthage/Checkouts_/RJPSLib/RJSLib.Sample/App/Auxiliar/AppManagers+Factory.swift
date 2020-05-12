//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit

extension UILabel {
    enum LayoutStyle {
        case notAplyed /// not Applied
        case title
        case value
    }
}

extension UIButton {
    enum LayoutStyle {
        case notAplyed /// not Applied
        case title
        case value
    }
}

extension UIView {
    func lazyLoad() {}
}

struct UIKitFactory {
    private init() {}
    static func label(baseView: UIView? = nil, title: String="", style: UILabel.LayoutStyle, tag: Int=0) -> UILabel {
        let some = UILabel()
        some.text = title
        some.numberOfLines = 0
        some.tag = tag
        baseView?.addSubview(some)
        return some
    }
    static func button(baseView: UIView? = nil, title: String="", style: UIButton.LayoutStyle, tag: Int=0) -> UIButton {
        let some = UIButton()
        some.tag = tag
        some.setTitleForAllStates(title)
        baseView?.addSubview(some)
        return some
    }
    static func imageView(baseView: UIView? = nil, image: UIImage?=nil, tag: Int=0) -> UIImageView {
        let some = UIImageView()
        some.tag = tag
        if image != nil {
            some.image = image
        }
        baseView?.addSubview(some)
        return some
    }
    static func tableView(baseView: UIView? = nil, tag: Int=0, cellIdentifier: String=AppConstants.cellIdentifier) -> UITableView {
        let some = UITableView()
        some.tag = tag
        some.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        baseView?.addSubview(some)
        return some
    }
    static func collectionView(baseController: GenericView,
                               itemSize: CGSize,
                               direction: UICollectionView.ScrollDirection) -> UICollectionView {
        let margin: CGFloat = 20
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset    = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.itemSize        = itemSize
        layout.scrollDirection = direction
        let some: UICollectionView = UICollectionView(frame: baseController.view.frame, collectionViewLayout: layout)
        some.dataSource = (baseController as? UICollectionViewDataSource)
        some.delegate   = (baseController as? UICollectionViewDelegate)
        some.register(UICollectionViewCell.self, forCellWithReuseIdentifier: AppConstants.cellIdentifier)
        some.backgroundColor = UIColor.brown
        baseController.view.addSubview(some)
        return some
    }
}
