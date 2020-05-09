//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit

extension AppManagers {
    
    struct Factory {
        private init() {}
    
        struct Errors {
            private init() {}
            static func with(appCode: AppEnuns.AppCodes, info: String="") -> Error {
                let domain: String = "\(Bundle.main.bundleIdentifier!)"//appCode.localizableString
                let code: Int = appCode.rawValue
                var userInfo: [String: Any] = [:]
                userInfo[NSError.AppKeys.userInfoDevMessageKey]  = appCode.localizedMessageForDevTeam
                userInfo[NSError.AppKeys.userInfoViewMessageKey] = appCode.localizedMessageForView
                userInfo[NSError.AppKeys.userInfoMoreInfoKey]    = info
                return NSError(domain: domain, code: code, userInfo: userInfo)
            }
        }
        
        struct UIKit {
            private init() {}
            
            static func textField(baseView: UIView? = nil, title: String="", tag: Int=0) -> UITextField {
                let some = UITextField()
                some.text = title
                some.tag = tag
                baseView?.addSubview(some)
                return some
            }
            
            static func label(baseView: UIView? = nil, title: String="", style: UILabel.LayoutStyle, tag: Int=0) -> UILabel {
                let some = UILabel()
                some.text = title
                some.numberOfLines = 0
                some.tag = tag
                some.layoutStyle = style
                baseView?.addSubview(some)
                return some
            }
            
            static func button(baseView: UIView? = nil, title: String="", style: UIButton.LayoutStyle, tag: Int=0) -> UIButton {
                let some = UIButton()
                some.tag = tag
                some.setTitleForAllStates(title)
                some.layoutStyle = style
                baseView?.addSubview(some)
                return some
            }
            
            static func searchBar(baseView: UIView? = nil, tag: Int=0) -> CustomSearchBar {
                let some = CustomSearchBar()
                baseView?.addSubview(some)
                some.tintColor = AppColors.TopBar.background
                some.tag = tag
                some.barStyle = .default
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

            static func tableView(baseView: UIView? = nil, tag: Int=0, cellIdentifier: String=AppConstants.Dev.cellIdentifier) -> UITableView {
                let some = UITableView()
                some.tag = tag
                if !cellIdentifier.trim.isEmpty {
                    some.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
                }
                baseView?.addSubview(some)
                return some
            }

            static func topBar(baseController: GenericView) -> V.TopBar {
                let bar         = V.TopBar()
                let screenWidth = UIScreen.main.bounds.width
                let height      = V.TopBar.defaultHeight
                let container   = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: height)))
                baseController.view.addSubview(container)
                UIViewController.rjs.loadViewControllerInContainedView(sender: baseController, senderContainedView: container, controller: bar) { (_, _) in }
                
                container.rjsALayouts.setMargin(0, on: .top)
                container.rjsALayouts.setMargin(0, on: .right)
                container.rjsALayouts.setMargin(0, on: .left)
                container.rjsALayouts.setHeight(V.TopBar.defaultHeight)
                
                bar.view.rjsALayouts.setMargin(0, on: .top)
                bar.view.rjsALayouts.setMargin(0, on: .right)
                bar.view.rjsALayouts.setMargin(0, on: .left)
                bar.view.rjsALayouts.setHeight(V.TopBar.defaultHeight)
                return bar
            }
            static func bottomBar(baseController: GenericView) -> V.BottomBar {
                let bar         = V.BottomBar()
                bar.view.backgroundColor = .clear
                let screenWidth = UIScreen.main.bounds.width
                let height      = V.TopBar.defaultHeight
                let container   = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: height)))
                baseController.view.addSubview(container)
                UIViewController.rjs.loadViewControllerInContainedView(sender: baseController, senderContainedView: container, controller: bar) { (_, _) in }
                
                container.rjsALayouts.setMargin(0, on: .bottom)
                container.rjsALayouts.setMargin(0, on: .right)
                container.rjsALayouts.setMargin(0, on: .left)
                container.rjsALayouts.setHeight(V.BottomBar.defaultHeight())
                container.backgroundColor = .clear
                
                bar.view.rjsALayouts.setMargin(0, on: .top)
                bar.view.rjsALayouts.setMargin(0, on: .right)
                bar.view.rjsALayouts.setMargin(0, on: .left)
                bar.view.rjsALayouts.setHeight(V.BottomBar.defaultHeight())
                return bar
            }
        }
    }
}
