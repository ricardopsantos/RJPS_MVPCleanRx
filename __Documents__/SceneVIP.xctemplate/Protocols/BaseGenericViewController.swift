//
//  BaseGenericViewController.swift
//  UIBase
//
//  Created by Ricardo Santos on 10/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import UIBase
import Designables
import DevTools

protocol ErrorDisplayerProtocol {

}

protocol LoadingDisplayerProtocol {

}

class BaseViewController: UIViewController, BaseDisplayLogicProtocol, StylableProtocol {
    func displayLoading(viewModel: LoadingModel.ViewModel) {
        DevTools.makeToast(viewModel.message, isError: false)
    }

    func displayError(viewModel: ErrorModel.ViewModel) {
        DevTools.makeToast(viewModel.message, isError: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setupColorsAndStyles() {

    }
}

class BaseGenericViewController<T: StylableView>: BaseViewController {

        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

    var displayer: (ErrorDisplayerProtocol & LoadingDisplayerProtocol)!
    var firstAppearance: Bool = true
    var genericView: T { view as! T }
    var disposeBag = DisposeBag()
    override func loadView() {
        super.loadView()
        view = T()
        setupViewUIRx()
    }

    func setup() {
        fatalError("override me")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewIfNeed()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUIRx()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearance = false
    }

    func setupViewIfNeed() {
        fatalError("Override me")
    }

    func setupViewUIRx() {
        fatalError("Override me")
    }

    func setupNavigationUIRx() {
        fatalError("Override me")
    }

}

extension UIView {
    func subViewsOf(type: UIKitViewFactoryElementTag, recursive: Bool) -> [UIView] {
        return self.subViewsWith(tag: type.rawValue, recursive: recursive)
    }

    func subViewsWith(tag: Int, recursive: Bool) -> [UIView] {
        if recursive {
            return self.getAllSubviews().filter { $0.tag == tag }
        } else {
            return self.subviews.filter { $0.tag == tag }
        }
    }
}

extension UIView {
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] { UIView.getAllSubviews(from: self) as [T] }

    func get<T: UIView>(all type: T.Type) -> [T] { UIView.getAllSubviews(from: self) as [T] }

    func get(all types: [UIView.Type]) -> [UIView] { UIView.getAllSubviews(from: self, types: types) }

    func bringToFront() { superview?.bringSubviewToFront(self) }

    func sendToBack() { superview?.sendSubviewToBack(self) }
}
