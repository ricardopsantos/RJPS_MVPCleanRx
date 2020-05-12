//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

//
// References
// http://stackoverflow.com/questions/26180822/swift-adding-constraints-programmatically
// https://medium.com/@KaushElsewhere/better-way-to-manage-swift-extensions-in-ios-project-78dc34221bc8
// https://theswiftdev.com/2018/06/14/mastering-ios-auto-layout-anchors-programmatically-from-swift/

// swiftlint:disable all

public protocol RJPSLayoutsCompatible {
    associatedtype RJPSLayoutsType
    var rjsALayouts: RJPSLayoutsType { get }
}

public extension RJPSLayoutsCompatible {
    var rjsALayouts: RJPSLayouts<Self> { return RJPSLayouts(self) }
}

public struct RJPSLayouts<Target> {
    let target: Target
    init(_ target: Target) {
        self.target = target
    }
}

extension UIView: RJPSLayoutsCompatible {}
extension NSLayoutConstraint: RJPSLayoutsCompatible {}

public struct RJSLayoutsConstants {
    public static let defaultAnimationsTime: Double = 0.3
    public static var defaultPriority: UILayoutPriority { return UILayoutPriority((UILayoutPriority.required.rawValue + UILayoutPriority.defaultHigh.rawValue) / 2) }
}

public enum RJSLayoutsMethod { case constraints, anchor }

public enum RJSLayoutsAttribute {
    case centerX
    case centerY
    case center
    case height
    case width
    case top
    case bottom
    case left, tailing
    case right, leading
}

public extension RJPSLayouts where Target: NSLayoutConstraint {

    var associatedViews: [UIView] {
        return [self.target.firstItem, self.target.secondItem].compactMap { $0 as? UIView }
    }
}

public extension RJPSLayouts where Target: UIView {

    /*
     * - 1000 é a prioridade mais alta
     * - Se quisermos aplicar esta classe, deveremos garantir que se existe no XIB uma constrainte semelhante, ela deverá
     *   ter prioridade inferior a 1000 (a prioridade por defeito que usamos). Se não fizermos isso, podemos ter conflitos de constraints
     */

    func printConstraints() {
        var count = 0
        var acc = ""
        allConstraints().forEach({ (constraint) in
            count += 1
            acc = "\(acc)# [\(count)] "
            if let identifier = constraint.identifier {
                acc = "\(acc)id: \(identifier)" + " | "
            }
            acc = "\(acc)value: \(constraint.constant)" + " | "
            acc = "\(acc)\(constraint)" + "\n"
        })
        print("\(acc)")
    }

    func removeAllConstraints() {
        allConstraints().forEach { (some) in
            self.target.removeConstraint(some)
            NSLayoutConstraint.deactivate([some])
        }
    }

    func allConstraints() -> [NSLayoutConstraint] {
        let target = self.target
        var tViews: [UIView] = [target]
        var tView: UIView = target
        while let superview = tView.superview {
            tViews.append(superview)
            tView = superview
        }
        return tViews.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == tView || constraint.secondItem as? UIView == tView
        }
    }

    // Example 1: Get all xxx constraints involving this view
    // We could have multiple constraints involving width, e.g.:
    // - two different width constraints with the exact same value
    // - this view's width equal to another view's width
    // - another view's height equal to this view's width (this view mentioned 2nd)
    func allConstraintsOf(type: RJSLayoutsAttribute, method: RJSLayoutsMethod = .anchor) -> [NSLayoutConstraint] {
        let tView = self.target
        if method == .constraints {
            switch type {
            case .width:
                return allConstraints().filter({
                    ($0.firstAttribute == .width && $0.firstItem as? UIView ==  tView) || ($0.secondAttribute == .width && $0.secondItem as? UIView == tView)
                })
            case .height:
                return allConstraints().filter({
                    ($0.firstAttribute == .height && $0.firstItem as? UIView ==  tView) || ($0.secondAttribute == .height && $0.secondItem as? UIView == tView)
                })
            default:
                return []
            }
        } else {
            print("\(#file)|\(#line):Not implemented \(method)")
            return []
        }
    }

    func updateConstraint(_ constraint: NSLayoutConstraint,
                                 toValue value: CGFloat,
                                 duration: Double = RJSLayoutsConstants.defaultAnimationsTime,
                                 priority: UILayoutPriority = RJSLayoutsConstants.defaultPriority+2,
                                 completion: @escaping (Bool) -> Void) {
        let tView = self.target
        tView.layoutIfNeeded()
        tView.updateConstraintsIfNeeded()
        if let superview = tView.superview {
            superview.layoutIfNeeded()
        }
        let doWork = {
            constraint.constant = value
            constraint.priority = priority
            tView.layoutIfNeeded()
            if let superview = tView.superview {
                superview.layoutIfNeeded()
            }
        }
        if duration>0 {
            UIView.animate(withDuration: duration, animations: {
                doWork()
            }, completion: { (_) in
                completion(true)
            })
        } else {
            doWork()
            completion(true)
        }
    }

    func constraintWith(identifier: String) -> NSLayoutConstraint? {
        return allConstraints().filter { $0.identifier == identifier }.first
    }

    @discardableResult
    func removeConstraintWithIdentifier(_ identifier: String) -> Bool {
        let tView = self.target
        let toRemove = constraintWith(identifier: identifier)
        if toRemove != nil {
            tView.removeConstraint(toRemove!)
            NSLayoutConstraint.deactivate([toRemove!])
        }
        let constraints = allConstraints().filter({ (some) -> Bool in some.identifier == identifier })
        tView.superview?.removeConstraints(constraints)
        tView.removeConstraints(constraints)
        return toRemove != nil
    }

    // MARK: Main

    private func activate(constraint: NSLayoutConstraint?, identifier: String, priority: UILayoutPriority, method: RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        if method == .constraints {
            assert(identifier.count > 0, "Invalid identifier")
            if constraint != nil {
                self.removeConstraintWithIdentifier(identifier)
                constraint!.identifier = identifier
                constraint!.priority   = priority
                NSLayoutConstraint.activate([constraint!])
            }
            return constraint
        } else {
            print("\(#file)|\(#line):Not implemented \(method)")
            return nil
        }
    }

    @discardableResult
    func setSame(_ property: RJSLayoutsAttribute,
                        as view: UIView,
                        priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority,
                        multiplier: CGFloat=1,
                        constant: CGFloat=0,
                        method: RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        let tView = self.target
        tView.translatesAutoresizingMaskIntoConstraints = false
        let toItem = view
        if method == .constraints {
            var constraint: NSLayoutConstraint?
            switch property {
            case .centerX:
                constraint = NSLayoutConstraint(item: tView, attribute: .centerX, relatedBy: .equal, toItem: toItem, attribute: .centerX, multiplier: multiplier, constant: constant)
            case .centerY:
                constraint = NSLayoutConstraint(item: tView, attribute: .centerY, relatedBy: .equal, toItem: toItem, attribute: .centerY, multiplier: multiplier, constant: constant)
            case .height:
                constraint = NSLayoutConstraint(item: tView, attribute: .height, relatedBy: .equal, toItem: toItem, attribute: .height, multiplier: multiplier, constant: constant)
            case .width:
                constraint = NSLayoutConstraint(item: tView, attribute: .width, relatedBy: .equal, toItem: toItem, attribute: .width, multiplier: multiplier, constant: constant)
            case .top:
                constraint = NSLayoutConstraint(item: tView, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: multiplier, constant: constant)
            case .bottom:
                constraint = NSLayoutConstraint(item: tView, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: multiplier, constant: constant)
            case .left, .tailing:
                constraint = NSLayoutConstraint(item: tView, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: multiplier, constant: constant)
            case .right, .leading:
                constraint = NSLayoutConstraint(item: tView, attribute: .trailing, relatedBy: .equal, toItem: toItem, attribute: .trailing, multiplier: multiplier, constant: constant)
            default:
                _ = 1
            }
            return activate(constraint: constraint, identifier: "id__same_\(property)_as_x", priority: priority)
        } else {
            switch property {
            case .centerX : tView.centerXAnchor.constraint(equalTo: toItem.centerXAnchor, constant: constant).isActive = true
            case .centerY : tView.centerYAnchor.constraint(equalTo: toItem.centerYAnchor, constant: constant).isActive = true
            case .height  : tView.heightAnchor.constraint(equalTo: toItem.heightAnchor, constant: constant * multiplier).isActive = true
            case .width   : tView.widthAnchor.constraint(equalTo: toItem.widthAnchor, constant: constant * multiplier).isActive = true
            case .top     : tView.topAnchor.constraint(equalTo: toItem.topAnchor, constant: constant).isActive = true
            case .bottom  : tView.bottomAnchor.constraint(equalTo: toItem.bottomAnchor, constant: constant).isActive = true
            case .left, .tailing : tView.trailingAnchor.constraint(equalTo: toItem.trailingAnchor, constant: constant).isActive = true
            case .right, .leading : tView.leadingAnchor.constraint(equalTo: toItem.leadingAnchor, constant: constant).isActive = true
            default:
                _ = 1
            }
            return nil
        }
    }

    @discardableResult
    func setMargin(_ margin: CGFloat,
                   on property: RJSLayoutsAttribute,
                   from: UIView?=nil,
                   priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority,
                   method: RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        let tView = self.target
        func existsWith(key: String) -> NSLayoutConstraint? {
            var nsLayoutConstraint: NSLayoutConstraint?
            for constraint in tView.constraints {
               if constraint.identifier == key {
                  nsLayoutConstraint = constraint
                }
            }
            return nsLayoutConstraint
        }
        tView.translatesAutoresizingMaskIntoConstraints = false
        var target = from
        var targetIsSuper = false
        if target == nil {
            target = tView.superview
            targetIsSuper = true
        }
        guard target != nil else {
            print("\(#file)|\(#line) : Target is nil. Ignored!")
            return nil
        }
        if method == .constraints {
            var constraint: NSLayoutConstraint?
            switch property {
            case .top:
                constraint = NSLayoutConstraint(item: tView, attribute: .top, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .top : .bottom, multiplier: 1, constant: margin)
            case .bottom:
                constraint = NSLayoutConstraint(item: tView, attribute: .bottom, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .bottom : .top, multiplier: 1, constant: -margin)
            case .left, .tailing:
                constraint = NSLayoutConstraint(item: tView, attribute: .leading, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .leading : .trailing, multiplier: 1, constant: margin)
            case .right, .leading:
                constraint = NSLayoutConstraint(item: tView, attribute: .trailing, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .trailing : .leading, multiplier: 1, constant: -margin)
            default:
                _ = 1
            }
            return activate(constraint: constraint, identifier: "id__margin_\(property)", priority: priority, method: method)
        } else {
            switch property {
            case .top:
                if targetIsSuper {
                    if #available(iOS 11.0, *) {
                        tView.topAnchor.constraint(equalTo: target!.safeAreaLayoutGuide.topAnchor, constant: margin).isActive = true
                    } else {
                        tView.topAnchor.constraint(equalTo: target!.topAnchor, constant: margin).isActive = true
                    }
                } else {
                    tView.topAnchor.constraint(equalTo: target!.bottomAnchor, constant: margin).isActive = true
                }
            case .bottom:
                let constant = margin
                // Add if statement for safe area check
                if targetIsSuper {
                    if #available(iOS 11.0, *) {
                        tView.bottomAnchor.constraint(equalTo: target!.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
                    } else {
                        tView.bottomAnchor.constraint(equalTo: target!.bottomAnchor, constant: -constant).isActive = true
                    }
                } else { tView.bottomAnchor.constraint(equalTo: target!.topAnchor, constant: constant).isActive = true }
            case .left, .tailing:
                let constant = margin
                if targetIsSuper {
                    tView.leftAnchor.constraint(equalTo: target!.leftAnchor, constant: constant).isActive = true
                } else {
                    tView.leftAnchor.constraint(equalTo: target!.rightAnchor, constant: constant).isActive = true
                }
            case .right, .leading:
                let constant = margin
                if targetIsSuper {
                    tView.rightAnchor.constraint(equalTo: target!.rightAnchor, constant: -constant).isActive = true
                } else { tView.rightAnchor.constraint(equalTo: target!.leftAnchor, constant: -constant).isActive = true }
            default:
                _ = 1
            }
            return nil
        }
    }

    @discardableResult
    func setValue(_ value: CGFloat, for property: RJSLayoutsAttribute, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority, method: RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        let tView = self.target
        func existsWith(key: String) -> NSLayoutConstraint? {
            var nsLayoutConstraint: NSLayoutConstraint?
            for constraint in tView.constraints {
               if constraint.identifier == key {
                  nsLayoutConstraint = constraint
                }
            }
            return nsLayoutConstraint
        }
        tView.translatesAutoresizingMaskIntoConstraints = false
        if method == .constraints {
            var constraint: NSLayoutConstraint?
            switch property {
            case .height:
                constraint = NSLayoutConstraint(item: tView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: value)
            case .width:
                constraint = NSLayoutConstraint(item: tView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: value)
            case .centerX:
                constraint = NSLayoutConstraint(item: tView, attribute: .centerX, relatedBy: .equal, toItem: tView.superview, attribute: .centerX, multiplier: 1, constant: value)
            case .centerY:
                constraint = NSLayoutConstraint(item: tView, attribute: .centerY, relatedBy: .equal, toItem: tView.superview, attribute: .centerY, multiplier: 1, constant: value)
            default:
                _ = 1
            }
            return activate(constraint: constraint, identifier: "id__margin_value_\(property)", priority: priority, method: method)
        } else {
            switch property {
            case .height:
                if let old = existsWith(key: "heightAnchor") {
                    old.constant = value
                    tView.layoutIfNeeded()
                    return old
                } else {
                    let anchor = tView.heightAnchor.constraint(equalToConstant: value)
                    anchor.priority = priority // priority must came before activate
                    anchor.isActive = true
                    anchor.identifier = "heightAnchor"
                    return anchor
                }
            case .width:
                if let old = existsWith(key: "widthAnchor") {
                    old.constant = value
                    tView.layoutIfNeeded()
                    return old
                } else {
                    let anchor = tView.widthAnchor.constraint(equalToConstant: value)
                    anchor.priority = priority // priority must came before activate
                    anchor.isActive = true
                    anchor.identifier = "widthAnchor"
                    return anchor
                }
            default:
                _ = 1
            }
            return nil
        }
    }

    @discardableResult
    func setHeight(_ value: CGFloat, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority, method: RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        return setValue(value, for: .height, priority: priority, method: method)
    }

    @discardableResult
    func setWidth(_ value: CGFloat, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority, method: RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        return setValue(value, for: .width, priority: priority, method: method)

    }

    @discardableResult
    func setHeightForAllSubViewWith(tag: Int, height: CGFloat, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority, method: RJSLayoutsMethod = .anchor) -> [NSLayoutConstraint?] {
        let tView = self.target
        return tView.rjsALayouts_getAllSubviews().filter { $0.tag == tag }.map { $0.rjsALayouts.setHeight(height, priority: priority) }
    }

    @discardableResult
    func setWidthForAllSubViewWith(tag: Int, width: CGFloat, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority, method: RJSLayoutsMethod = .anchor) -> [NSLayoutConstraint?] {
        let tView = self.target
        return tView.rjsALayouts_getAllSubviews().filter { $0.tag == tag }.map { $0.rjsALayouts.setWidth(width, priority: priority) }
    }

    @discardableResult
    func setMarginFromSuperview(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority) -> [NSLayoutConstraint?] {
        let constraint1 = self.setMargin(top, on: .top, priority: priority)
        let constraint2 = self.setMargin(bottom, on: .bottom, priority: priority)
        let constraint3 = self.setMargin(left, on: .left, priority: priority)
        let constraint4 = self.setMargin(right, on: .right, priority: priority)
        return [constraint1, constraint2, constraint3, constraint4]
    }

    @discardableResult
    func setCenter(_ center: CGPoint, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority, contentView: UIView) -> [NSLayoutConstraint?] {
        let constraint1 = setValue(center.x, for: .centerX, priority: priority)
        let constraint2 = setValue(center.y, for: .centerY, priority: priority)
        return [constraint1, constraint2]
    }

    @discardableResult
    func setSize(_ size: CGSize, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority) -> [NSLayoutConstraint?] {
        let constraint1 = setValue(size.width, for: .width, priority: priority)
        let constraint2 = setValue(size.height, for: .height, priority: priority)
        return [constraint1, constraint2]
    }

}

//
// MARK: - Hugging & Compression
//

public extension RJPSLayouts where Target: UIView {
    // Hugging                =>  Dont want to grow
    // Compression Resistance =>  Dont want to shrink
    func addLowResistanceToGrow(_ priority: UILayoutPriority = .defaultLow, axis: NSLayoutConstraint.Axis) {
        if priority > .defaultLow {
            print("\(#file)|\(#line) : Too higth?!")
        }
        self.target.setContentHuggingPriority(priority, for: axis)
    }
    func addHightResistanceToGrow(_ priority: UILayoutPriority = .defaultHigh, axis: NSLayoutConstraint.Axis) {
        if priority > .defaultLow {
            print("\(#file)|\(#line) : Too low?!")
        }
        self.target.setContentHuggingPriority(priority, for: axis)
    }
}

//
// MARK: - Tiny constraints sintaxe
//https://github.com/roberthein/TinyConstraints
//

public extension RJPSLayouts where Target: UIView {

    @discardableResult
    func topToBottom(of view: UIView, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority) -> NSLayoutConstraint? {
        return setMargin(0, on: .top, from: view)
    }

    @discardableResult
    func topToBottomOfSuperView(priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority) -> NSLayoutConstraint? {
        return setMargin(0, on: .top)
    }

    @discardableResult
    func edgesToSuperview(priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority) -> [NSLayoutConstraint?] {
        return setMarginFromSuperview(top: 0, bottom: 0, left: 0, right: 0, priority: priority)
    }

    @discardableResult
    func width(to view: UIView, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority) -> NSLayoutConstraint? {
        return setSame(.width, as: view, priority: priority)
    }

    @discardableResult
    func height(to view: UIView, priority: UILayoutPriority=RJSLayoutsConstants.defaultPriority) -> NSLayoutConstraint? {
        return setSame(.height, as: view, priority: priority)
    }

    @discardableResult
    func height(_ value: CGFloat) -> NSLayoutConstraint? {
        return setHeight(value)
    }

    @discardableResult
    func width(_ value: CGFloat) -> NSLayoutConstraint? {
        return setWidth(value)
    }

    @discardableResult
    func heightToSuperview() -> [NSLayoutConstraint?] {
        let c1 = setMargin(0, on: .top)
        let c2 = setMargin(0, on: .bottom)
        return [c1, c2]
    }

    @discardableResult
    func widthToSuperview() -> [NSLayoutConstraint?] {
        let c1 = setMargin(0, on: .left)
        let c2 = setMargin(0, on: .right)
        return [c1, c2]
    }
}

//
//MARK:- Extensions
//

fileprivate extension UIView {

    class func rjsALayouts_getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = rjsALayouts_getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func rjsALayouts_getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = rjsALayouts_getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func rjsALayouts_getAllSubviews<T: UIView>() -> [T] { return UIView.rjsALayouts_getAllSubviews(from: self) as [T] }
    func rjsALayouts_get<T: UIView>(all type: T.Type) -> [T] { return UIView.rjsALayouts_getAllSubviews(from: self) as [T] }
    func rjsALayouts_get(all types: [UIView.Type]) -> [UIView] { return UIView.rjsALayouts_getAllSubviews(from: self, types: types) }
}
