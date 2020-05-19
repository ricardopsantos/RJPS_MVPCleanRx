//
//  UIViewContoller+ExtensionsAlerts.swift
//  Extensions
//
//  Created by Ricardo Santos on 19/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
/*
extension UIAlertAction {
    static var ok: UIAlertAction {
        ok {}
    }

    static func ok(title: String = "OK", completion: @escaping () -> Void) -> UIAlertAction {
        UIAlertAction(
            title: title,
            style: .default,
            handler: { _ in
                completion()
            })
    }

    static func okWithTitle(title: String = "OK", completion: @escaping () -> Void) -> UIAlertAction {
        ok(title: title) {
            completion()
        }
    }

    static func ok(completion: @escaping () -> Void) -> UIAlertAction {
        UIAlertAction(title: "OK",
                      style: .cancel,
                      handler: { _ in
                          completion()
                      })
    }

    static func cancel(title: String = "Cancel") -> UIAlertAction {
        UIAlertAction(title: title, style: .cancel)
    }

    static func cancel(title: String = "Cancel",
                       completion: @escaping () -> Void) -> UIAlertAction {
        UIAlertAction(
            title: title,
            style: .cancel,
            handler: { _ in
                completion()
            })
    }

    static var cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel)
    }

    static func save(completion: @escaping () -> Void) -> UIAlertAction {
        UIAlertAction(
            title: "Save,
            style: .default,
            handler: { _ in
                completion()
            })
    }
}


public struct OptionItem<ItemType> {
    let item: ItemType?
    let title: String?
}

public struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: (() -> Void)?
}

public extension UIViewController {


    private static var alertTag = 1001

    func alert(title: String, message: String,
               cancelButtonText: String,
               confirmationButtonText: String,
               confirmationAction: @escaping () -> Void,
               cancelAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction: UIAlertAction
        confirmAction = UIAlertAction(title: confirmationButtonText, style: .default) { _ in
            confirmationAction()
        }
        let cancelAction = UIAlertAction(title: cancelButtonText, style: .cancel) { _ in
            cancelAction()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }

    func alert(title: String?,
               message: String?,
               preferredStyle: UIAlertController.Style = .actionSheet,
               actions: [AlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { item in
            let action = UIAlertAction(title: item.title, style: item.style) { _ in
                if let doAction = item.action {
                    doAction()
                }
            }
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }

    func showOkAlert(title: String = "", message: String, actionTitle: String, completion: (() -> Void)? = nil, animated: Bool = true) {
        showAlertWithActions(title: title, message: message, actions: [.ok(title: actionTitle, completion: { completion?() })], animated: animated)
    }

    func showOkAlert(title: String = "", message: String, completion: (() -> Void)? = nil, animated: Bool = true) {
        showAlertWithActions(title: title, message: message, actions: [.ok { completion?() }], animated: animated)
    }

    func showAlertWithActions(title: String, message: String, actions: [UIAlertAction], animated: Bool = true) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alert.addAction)
        present(alert, animated: animated)
    }

    func showAlertWithPicker<T>(options: [OptionItem<T>],
                                disposeBag: DisposeBag,
                                doneTitle: String,
                                cancelTitle: String,
                                confirmationAction: @escaping (OptionItem<T>?) -> Void) {
        if self.navigationController?
               .view
               .subviews
               .first(where: { $0.tag == 1001 }) != nil {
            return
        }
        // store selected item
        var item: OptionItem<T>?
        // TextField
        let textField = UITextField()
        textField.tag = AppConstants.Tags.tag_1000
        textField.isHidden = true
        // Toolbar above the keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // Button for toolbar
        let cancelButton = UIBarButtonItem(title: cancelTitle, style: .done, target: self, action: nil)
        let spaceFlex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: doneTitle, style: .done, target: self, action: nil)
        toolBar.items = [cancelButton, spaceFlex, doneButton]
        textField.inputAccessoryView = toolBar
        // Picker view to show goals names
        let pickerFrame = UIPickerView()
        pickerFrame.backgroundColor = ColorName.background.uiColor
        // Rx to bind the picker view with options sent from viewcontroller
        Observable.just(options)
            .bind(to: pickerFrame.rx.itemTitles) { _, itemPick in
                return itemPick.title
            }
            .disposed(by: disposeBag)
        pickerFrame.rx.itemSelected
            .subscribe(onNext: { [weak self] itemSelected in
                guard let maybeItem = options.item(at: itemSelected.row) else {
                    self?.cleanViews()
                    return
                }
                item = maybeItem
            })
            .disposed(by: disposeBag)
        // Background view with
        let backView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: self.view.bounds.width,
                                            height: self.view.bounds.height))
        // Tag to find this view and than remove it
        backView.tag = UIViewController.alertTag
        //backView.backgroundColor = ColorName.i9CloudLabelFooterColor.uiColor
        textField.inputView = pickerFrame
        // Add to navigation controller to be on top and cover balance, filter, search
        self.navigationController?.view.addSubview(backView)
        self.view.addSubview(textField)
        // Open keyboard
        textField.becomeFirstResponder()
        // Rx to cancel button
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.cleanViews()
        }).disposed(by: disposeBag)
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.cleanViews()
            confirmationAction(item)
        }).disposed(by: disposeBag)
    }

    private func cleanViews() {
        let view = self.navigationController?
            .view
            .subviews
            .first(where: { $0.tag == UIViewController.alertTag })
        let textField = self.view
            .subviews
            .first(where: { $0.tag == UIViewController.alertTag })
        DispatchQueue.main.async {
            view?.removeFromSuperview()
            textField?.removeFromSuperview()
        }
    }
}
*/
