//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib

struct Source1 {
    let title: String
}

struct Presenter { private init() {} }

extension AppView {
    
    class SampleUITestingA_View: GenericView {
        
        var viewWidthConstraint: NSLayoutConstraint!
        var viewMarginTopConstraint: NSLayoutConstraint!

        let screenWidth  = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        private lazy var _btn1: UIButton = {
            let size: CGSize = CGSize(width: (screenWidth*0.2), height: (screenWidth*0.2))
            let some = UIButton()
            self.view.addSubview(some)
            some.backgroundColor = .green
            some.setTitleForAllStates("_btn1")
            some.rjsALayouts.setMargin(50, on: .top, from: _inputField)
            some.rjsALayouts.setMargin(50, on: .left)
            some.rjsALayouts.setSize(size)
            some.onTouchUpInside { [weak self] in
                guard let strongSelf = self else { return RJS_Logs.DLog("\(RJS_Constants.referenceLost)") }
                strongSelf._inputField?.resignFirstResponder()
                some.bumpAndPerform {
                    RJS_Logs.DLog("_btn1 pressed")
                }
            }
            return some
        }()
      
        private lazy var _btn2: UIButton = {
            let size: CGSize = CGSize(width: (screenWidth*0.2), height: (screenWidth*0.2))
            let some = UIButton()
            self.view.addSubview(some)
            some.backgroundColor = .red
            some.setTitleForAllStates("_btn2")
            some.rjsALayouts.setMargin(50, on: .top, from: _inputField)
            some.rjsALayouts.setMargin(50, on: .right)
            some.rjsALayouts.setSame(.width, as: _btn1)
            some.rjsALayouts.setSame(.height, as: _btn1)
            some.onTouchUpInside { [weak self] in
                guard let strongSelf = self else { return RJS_Logs.DLog("\(RJS_Constants.referenceLost)") }
                strongSelf._inputField?.resignFirstResponder()
                some.bumpAndPerform {
                    RJS_Logs.DLog("_btn2 pressed")
                    
                }
            }
            return some
        }()
        
        private lazy var _inputField: UITextField? = {
            let some = RJS_Designables_InputField.madokaTextField()
            self.view.addSubview(some)
            some.text = "Hi there"
            some.placeholder = "Placeholder"
            some.rjsALayouts.setMargin(50, on: .top)
            some.rjsALayouts.setMargin(50, on: .left)
            some.rjsALayouts.setMargin(50, on: .right)
            some.rjsALayouts.setHeight(40)
            return some
        }()
        
        private lazy var _collectionView1: UICollectionView = {
            let itemSizeK: CGFloat = 0.8
            let itemSize: CGSize = CGSize(width: (screenWidth*0.8), height: (screenHeight/2)*itemSizeK)
            let some = UIKitFactory.collectionView(baseController: self, itemSize: itemSize, direction: .horizontal)
            some.backgroundColor = .brown
            some.rjsALayouts.setMargin(0, on: .top)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setHeight(screenHeight/4)
            return some
        }()
        
        private lazy var _viewChangingWidth: UIView = {
            let some = UIView()
            self.view.addSubview(some)
            some.backgroundColor = .brown
            some.rjsALayouts.setSame(.centerX, as: self.view, method: .constraints)
            viewMarginTopConstraint = some.rjsALayouts.setMargin(10, on: .top, method: .constraints)
            viewWidthConstraint     = some.rjsALayouts.setValue(UIScreen.main.bounds.width * 0.8, for: .width, method: .constraints)
            some.rjsALayouts.setHeight(200)
            some.backgroundColor = .yellow
            return some
        }()
        
        private lazy var _collectionView2: UICollectionView = {
            let itemSizeK: CGFloat = 0.8
            let itemSize: CGSize = CGSize(width: (screenWidth/2)*itemSizeK, height: (screenHeight/2)*itemSizeK)
            let some = UIKitFactory.collectionView(baseController: self, itemSize: itemSize, direction: .vertical)
            some.backgroundColor = .orange
            some.rjsALayouts.setMargin(0, on: .top, from: _collectionView1)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setMargin(0, on: .right)
            let overlap: CGFloat = 0//V.BottomBar.defaultHeight() - V.BottomBar.backgroundHeight()
            some.rjsALayouts.setMargin(overlap, on: .bottom)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            prepareLayout()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        
        private lazy var _lbl1: UILabel = {
            let label = UILabel()
            self.view.addSubview(label)
            label.backgroundColor = .green
            label.rjsALayouts.setMargin(50, on: .top)
            label.rjsALayouts.setMargin(50, on: .left)
            label.rjsALayouts.setHeight(50)
            let imageView = UIImageView()
            imageView.image = UIImage(named: "sampleImage")
            self.view.addSubview(imageView)
            imageView.rjsALayouts.setMargin(50, on: .top)
            imageView.rjsALayouts.setMargin(50, on: .left, from: label)
            imageView.rjsALayouts.setHeight(50)
            return label
        }()
        
        func prepareLayout() {
            
            self.view.backgroundColor = .white
            _collectionView1.lazyLoad()
            _collectionView2.lazyLoad()
            _viewChangingWidth.lazyLoad()
                _btn1.lazyLoad()
                _btn2.lazyLoad()
                _inputField?.lazyLoad()
        }
    }
}

// MARK: - View Protocol

extension V.SampleUITestingA_View: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func dataSource_1() -> [Source1] {
        return [Source1(title: "1.1"),
                Source1(title: "1.2"),
                Source1(title: "1.3")
        ]
    }
    
    func dataSource_2() -> [Source1] {
        return [Source1(title: "2.1"),
                Source1(title: "2.2"),
                Source1(title: "2.3"),
                Source1(title: "2.4"),
                Source1(title: "2.5"),
                Source1(title: "2.6")
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == _collectionView1 {
            return dataSource_1().count
        } else {
            return dataSource_2().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == _collectionView1 {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.cellIdentifier, for: indexPath as IndexPath)
            myCell.backgroundColor = UIColor.blue
            let item = dataSource_1()[indexPath.row]
            _ = myCell.subviews.map { $0.removeFromSuperview() }
            let label = UIKitFactory.label(title: item.title, style: .value)
            label.textAlignment = .center
            myCell.addSubview(label)
            label.rjsALayouts.setMargin(0, on: .top)
            label.rjsALayouts.setMargin(0, on: .left)
            label.rjsALayouts.setMargin(0, on: .bottom)
            label.rjsALayouts.setMargin(0, on: .right)
            return myCell
        } else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.cellIdentifier, for: indexPath as IndexPath)
            myCell.backgroundColor = UIColor.blue
            let item = dataSource_2()[indexPath.row]
            _ = myCell.subviews.map { $0.removeFromSuperview() }
            let label = UIKitFactory.label(title: item.title, style: .value)
            label.textAlignment = .center
            myCell.addSubview(label)
            label.rjsALayouts.setMargin(0, on: .top)
            label.rjsALayouts.setMargin(0, on: .left)
            label.rjsALayouts.setMargin(0, on: .bottom)
            label.rjsALayouts.setMargin(0, on: .right)
            return myCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RJS_Logs.DLog("User tapped on item \(indexPath.row)")
    }
    
}
