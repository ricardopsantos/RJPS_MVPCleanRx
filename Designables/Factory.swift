//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Extensions
import AppResources
import UIBase

public typealias CustomSearchBar = RJS_CustomSearchBar

    public struct Factory {
        private init() {}
    
        public struct Errors {
            private init() {}
            public static func with(appCode: AppCodes, info: String="") -> Error {
                let domain: String = "\(Bundle.main.bundleIdentifier!)"//appCode.localizableString
                let code: Int = appCode.rawValue
                var userInfo: [String: Any] = [:]
                #warning("uncoment")
                //userInfo[NSError.AppKeys.userInfoDevMessageKey]  = appCode.localizedMessageForDevTeam
                //userInfo[NSError.AppKeys.userInfoViewMessageKey] = appCode.localizedMessageForView
                //userInfo[NSError.AppKeys.userInfoMoreInfoKey]    = info
                return NSError(domain: domain, code: code, userInfo: userInfo)
            }
        }
        
        public struct UIKit {
            private init() {}
            
            public static func textField(baseView: UIView? = nil, title: String="", tag: Int=0) -> UITextField {
                let some = UITextField()
                some.text = title
                some.tag = tag
                baseView?.addSubview(some)
                return some
            }
            
            public static func label(baseView: UIView? = nil, title: String="", style: UILabel.LayoutStyle, tag: Int=0) -> UILabel {
                let some = UILabel()
                some.text = title
                some.numberOfLines = 0
                some.tag = tag
                some.layoutStyle = style
                baseView?.addSubview(some)
                return some
            }
            
            public static func button(baseView: UIView? = nil, title: String="", style: UIButton.LayoutStyle, tag: Int=0) -> UIButton {
                let some = UIButton()
                some.tag = tag
                some.setTitleForAllStates(title)
                some.layoutStyle = style
                baseView?.addSubview(some)
                return some
            }
            
            public static func searchBar(baseView: UIView? = nil, tag: Int=0) -> CustomSearchBar {
                let some = CustomSearchBar()
                baseView?.addSubview(some)
                some.tintColor = UIColor.App.TopBar.background
                some.tag = tag
                some.barStyle = .default
                return some
            }
            
            public static func imageView(baseView: UIView? = nil, image: UIImage?=nil, tag: Int=0) -> UIImageView {
                let some = UIImageView()
                some.tag = tag
                if image != nil {
                    some.image = image
                }
                baseView?.addSubview(some)
                return some
            }

            public static func tableView(baseView: UIView? = nil, tag: Int=0, cellIdentifier: String=AppConstants.Dev.cellIdentifier) -> UITableView {
                let some = UITableView()
                some.tag = tag
                if !cellIdentifier.trim.isEmpty {
                    some.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
                }
                baseView?.addSubview(some)
                return some
            }

            public static func topBar(baseController: GenericView) -> TopBar {
                let bar         = TopBar()
                let screenWidth = UIScreen.main.bounds.width
                let height      = TopBar.defaultHeight
                let container   = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: height)))
                baseController.view.addSubview(container)
                UIViewController.rjs.loadViewControllerInContainedView(sender: baseController, senderContainedView: container, controller: bar) { (_, _) in }
                
                container.rjsALayouts.setMargin(0, on: .top)
                container.rjsALayouts.setMargin(0, on: .right)
                container.rjsALayouts.setMargin(0, on: .left)
                container.rjsALayouts.setHeight(TopBar.defaultHeight)
                
                bar.view.rjsALayouts.setMargin(0, on: .top)
                bar.view.rjsALayouts.setMargin(0, on: .right)
                bar.view.rjsALayouts.setMargin(0, on: .left)
                bar.view.rjsALayouts.setHeight(TopBar.defaultHeight)
                return bar
            }

            public static func bottomBar(baseController: GenericView) -> BottomBar {
                let bar         = BottomBar()
                bar.view.backgroundColor = .clear
                let screenWidth = UIScreen.main.bounds.width
                let height      = TopBar.defaultHeight
                let container   = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: height)))
                baseController.view.addSubview(container)
                UIViewController.rjs.loadViewControllerInContainedView(sender: baseController, senderContainedView: container, controller: bar) { (_, _) in }
                
                container.rjsALayouts.setMargin(0, on: .bottom)
                container.rjsALayouts.setMargin(0, on: .right)
                container.rjsALayouts.setMargin(0, on: .left)
                container.rjsALayouts.setHeight(BottomBar.defaultHeight())
                container.backgroundColor = .clear
                
                bar.view.rjsALayouts.setMargin(0, on: .top)
                bar.view.rjsALayouts.setMargin(0, on: .right)
                bar.view.rjsALayouts.setMargin(0, on: .left)
                bar.view.rjsALayouts.setHeight(BottomBar.defaultHeight())
                return bar
            }
        }
    }
//}
