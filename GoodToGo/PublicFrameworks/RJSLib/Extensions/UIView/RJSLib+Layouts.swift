//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

//
// Referencias - http://stackoverflow.com/questions/26180822/swift-adding-constraints-programmatically
// https://medium.com/@KaushElsewhere/better-way-to-manage-swift-extensions-in-ios-project-78dc34221bc8
// https://theswiftdev.com/2018/06/14/mastering-ios-auto-layout-anchors-programmatically-from-swift/

enum RJSLayoutsMethod { case constraints, anchor }

enum RJSLayoutsAttribute {
    case centerX
    case centerY
    case center
    case height
    case width
    case top
    case bottom
    case left
    case right
}

private func defautPriority() -> UILayoutPriority { return .required /* .defaultHigh */ }

extension RJPSLayouts where Target: UIView {
    
    
    /*
     * - 1000 é a prioridade mais alta
     * - Se quisermos aplicar esta classe, deveremos garantir que se existe no XIB uma constrainte semelhante, ela deverá
     *   ter prioridade inferior a 1000 (a prioridade por defeito que usamos). Se não fizermos isso, podemos ter conflitos de constraints
     */
    
    func printConstraints() {
        var c = 0
        var acc = ""
        allConstraints().forEach({ (constraint) in
            c += 1
            acc = acc + "# [\(c)] "
            if let identifier = constraint.identifier {
                acc = acc + "id: \(identifier)" + " | "
            }
            acc = acc + "value: \(constraint.constant)" + " | "
            acc = acc + "\(constraint)" + "\n"
        })
        acc = acc.replace("<NSLayoutConstraint:", with: "")
        acc = acc.replace("(active)>", with: "")
        print("\(acc)")
    }
    
    func removeAllConstraints() -> Void {
        allConstraints().forEach { (some) in
            self.target.removeConstraint(some)
            NSLayoutConstraint.deactivate([some])
        }
    }
    
    func allConstraints() -> [NSLayoutConstraint] {
        let target = self.target
        var tViews : [UIView] = [target]
        var tView  : UIView = target
        if(true) {
            while let superview = tView.superview {
                tViews.append(superview)
                tView = superview
            }
            return tViews.flatMap({ $0.constraints }).filter { constraint in
                return constraint.firstItem as? UIView == tView || constraint.secondItem as? UIView == tView
            }
        }
        else {
            return tView.superview?.constraints.filter{ $0.firstItem as? UIView == tView || $0.secondItem as? UIView == tView } ?? []
        }
    }
    
    // Example 1: Get all xxx constraints involving this view
    // We could have multiple constraints involving width, e.g.:
    // - two different width constraints with the exact same value
    // - this view's width equal to another view's width
    // - another view's height equal to this view's width (this view mentioned 2nd)
    func allConstraintsOf(type:RJSLayoutsAttribute, method:RJSLayoutsMethod = .anchor) -> [NSLayoutConstraint] {
        let tView = self.target
        if(method == .constraints) {
            switch type {
            case .width:
                return allConstraints().filter( {
                    ($0.firstAttribute == .width && $0.firstItem as? UIView ==  tView) || ($0.secondAttribute == .width && $0.secondItem as? UIView == tView)
                } )
            case .height:
                return allConstraints().filter( {
                    ($0.firstAttribute == .height && $0.firstItem as? UIView ==  tView) || ($0.secondAttribute == .height && $0.secondItem as? UIView == tView)
                } )
            default:
                return []
            }
        }
        else {
            RJSLib.Logs.DLogError("Not implemented \(method)")
            return []
        }
    }
    
    // Change xxx constraint(s) of this view to a specific value
    // Make sure that we are looking at an equality constraint (not inequality)
    // and that the constraint is not against another view
    func changeAtribute(_ atribute:RJSLayoutsAttribute, to value: CGFloat) -> Void {
        let tView = self.target
        switch atribute {
        case .width:
            allConstraints().filter( { $0.firstAttribute == .width && $0.relation == .equal && $0.secondAttribute == .notAnAttribute } ).forEach( {$0.constant = value })
            break
        case .height:
            allConstraints().filter( { $0.firstAttribute == .height && $0.relation == .equal && $0.secondAttribute == .notAnAttribute } ).forEach( {$0.constant = value })
            break
        case .right:
            allConstraints().filter( { $0.firstAttribute == .leading && $0.firstItem as? UIView == tView }).forEach({$0.constant = value})
        case .left:
            allConstraints().filter( { $0.firstAttribute == .trailing && $0.firstItem as? UIView == tView }).forEach({$0.constant = value})
        default:
            let _ = 1
        }
    }
    
    func constraintWith(identifier:String) -> NSLayoutConstraint? {
        var result : NSLayoutConstraint?
        for c in allConstraints() {
            if(c.identifier == identifier) {
                result = c
                break
            }
        }
        return result
    }
    
    @discardableResult fileprivate func removeConstraintWithIdentifier(_ identifier:String)->Bool {
        let tView = self.target
        let toRemove = constraintWith(identifier: identifier)
        if(toRemove != nil) {
            tView.removeConstraint(toRemove!)
            NSLayoutConstraint.deactivate([toRemove!])
        }
        let constraints = allConstraints().filter({ (some) -> Bool in some.identifier == identifier })
        tView.superview?.removeConstraints(constraints)
        tView.removeConstraints(constraints)
        return toRemove != nil
    }
    
    // MARK: Main
    
    private func activate(constraint:NSLayoutConstraint?, identifier:String, priority:UILayoutPriority, method:RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        if(method == .constraints) {
            assert(identifier.length > 0, "Invalid identifier")
            if let _ = constraint {
                self.removeConstraintWithIdentifier(identifier)
                constraint!.identifier = identifier
                constraint!.priority   = priority
                NSLayoutConstraint.activate([constraint!])
            }
            return constraint
        }
        else {
            RJSLib.Logs.DLogError("Not implemented \(method)")
            return nil
        }
    }
    
    @discardableResult
    func setSame(_ property:RJSLayoutsAttribute, as view:UIView, priority:UILayoutPriority=defautPriority(), multiplier:CGFloat=1, constant:CGFloat=0, method:RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        let tView = self.target
        tView.translatesAutoresizingMaskIntoConstraints = false
        let toItem = view
        if(method == .constraints) {
            var constraint : NSLayoutConstraint?
            switch property {
            case .centerX:
                constraint = NSLayoutConstraint(item: tView, attribute: .centerX, relatedBy: .equal, toItem: toItem, attribute: .centerX, multiplier: multiplier, constant: constant)
            case .centerY:
                constraint = NSLayoutConstraint(item: tView, attribute: .centerY, relatedBy: .equal, toItem: toItem, attribute: .centerY, multiplier: multiplier, constant: constant)
            case .height:
                constraint = NSLayoutConstraint(item:tView, attribute: .height, relatedBy: .equal, toItem: toItem, attribute: .height, multiplier: multiplier, constant: constant)
            case .width:
                constraint = NSLayoutConstraint(item: tView, attribute: .width, relatedBy: .equal, toItem: toItem, attribute: .width, multiplier: multiplier, constant: constant)
            case .top:
                constraint = NSLayoutConstraint(item: tView, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: multiplier, constant: constant)
            case .bottom:
                constraint = NSLayoutConstraint(item: tView, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: multiplier, constant: constant)
            case .left:
                constraint = NSLayoutConstraint(item: tView, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: multiplier, constant: constant)
            case .right:
                constraint = NSLayoutConstraint(item: tView, attribute: .trailing, relatedBy: .equal, toItem: toItem, attribute: .trailing, multiplier: multiplier, constant: constant)
            default:
                let _ = 1
            }
            return activate(constraint: constraint, identifier: "id__same_\(property)_as_x", priority: priority)
        }
        else {
            switch property {
            case .centerX:
                tView.centerXAnchor.constraint(equalTo: toItem.centerXAnchor, constant: constant).isActive = true
            case .centerY:
                tView.centerYAnchor.constraint(equalTo: toItem.centerYAnchor, constant: constant).isActive = true
            case .height:
                tView.heightAnchor.constraint(equalTo: toItem.heightAnchor, constant: constant * multiplier).isActive = true
            case .width:
                tView.widthAnchor.constraint(equalTo: toItem.widthAnchor, constant: constant * multiplier).isActive = true
            case .top:
                tView.topAnchor.constraint(equalTo: toItem.topAnchor, constant: constant).isActive = true
            case .bottom:
                tView.bottomAnchor.constraint(equalTo: toItem.bottomAnchor, constant: constant).isActive = true
            case .left:
                tView.trailingAnchor.constraint(equalTo: toItem.trailingAnchor, constant: constant).isActive = true
            case .right:
                tView.leadingAnchor.constraint(equalTo: toItem.leadingAnchor, constant: constant).isActive = true
            default:
                let _ = 1
            }
            return nil
        }
    }
    
    @discardableResult
    func setMargin(_ margin:CGFloat, on property:RJSLayoutsAttribute, from:UIView?=nil, priority:UILayoutPriority=defautPriority(), method:RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        let tView = self.target
        tView.translatesAutoresizingMaskIntoConstraints = false
        var target = from
        var targetIsSuper = false
        if(target == nil) {
            target = tView.superview
            targetIsSuper = true
        }
        guard target != nil else {
            RJSLib.Logs.DLogError("Target is nil")
            return nil
        }
        if(method == .constraints) {
            var constraint : NSLayoutConstraint?
            switch property {
            case .top:
                constraint = NSLayoutConstraint(item: tView, attribute: .top, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .top : .bottom, multiplier: 1, constant: margin)
            case .bottom:
                constraint = NSLayoutConstraint(item: tView, attribute: .bottom, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .bottom : .top, multiplier: 1, constant: -margin)
            case .left:
                constraint = NSLayoutConstraint(item: tView, attribute: .leading, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .leading : .trailing, multiplier: 1, constant: margin)
            case .right:
                constraint = NSLayoutConstraint(item: tView, attribute: .trailing, relatedBy: .equal, toItem: target, attribute: targetIsSuper ? .trailing : .leading, multiplier: 1, constant: -margin)
            default:
                let _ = 1
            }
            return activate(constraint: constraint, identifier: "id__margin_\(property)", priority: priority)
        }
        else {
            switch property {
            case .top:
                if(targetIsSuper) {
                    if #available(iOS 11.0, *) {
                        tView.topAnchor.constraint(equalTo: target!.safeAreaLayoutGuide.topAnchor, constant: margin).isActive = true
                    }
                    else {
                        tView.topAnchor.constraint(equalTo: target!.topAnchor, constant: margin).isActive = true
                    }
                }
                else {
                    tView.topAnchor.constraint(equalTo: target!.bottomAnchor, constant: margin).isActive = true
                }
                break
            case .bottom:
                let constant = margin
                // Add if statement for safe area check
                if(targetIsSuper) {
                    if #available(iOS 11.0, *) {
                        tView.bottomAnchor.constraint(equalTo: target!.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
                    }else{
                        tView.bottomAnchor.constraint(equalTo: target!.bottomAnchor, constant: -constant).isActive = true
                    }
                }
                else { tView.bottomAnchor.constraint(equalTo: target!.topAnchor, constant: constant).isActive = true }
                break
            case .left:
                let constant = margin
                if(targetIsSuper) { tView.leftAnchor.constraint(equalTo: target!.leftAnchor, constant: constant).isActive = true }
                else { tView.leftAnchor.constraint(equalTo: target!.rightAnchor, constant: constant).isActive = true }
                break
            case .right:
                let constant = margin
                if(targetIsSuper) { tView.rightAnchor.constraint(equalTo: target!.rightAnchor, constant: -constant).isActive = true }
                else { tView.rightAnchor.constraint(equalTo: target!.leftAnchor, constant: -constant).isActive = true }
                break
            default:
                let _ = 1
            }
            return nil
        }
    }
    
    @discardableResult
    func setValue(_ value:CGFloat, for property:RJSLayoutsAttribute, priority:UILayoutPriority=defautPriority(), method:RJSLayoutsMethod = .anchor) -> NSLayoutConstraint? {
        let tView = self.target
        tView.translatesAutoresizingMaskIntoConstraints = false
        if(method == .constraints) {
            var constraint : NSLayoutConstraint?
            switch property {
            case .height:
                constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height,  multiplier: 1, constant: value)
            case .width:
                constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width,  multiplier: 1, constant: value)
            case .centerX:
                constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: tView.superview, attribute: .centerX,  multiplier: 1, constant: value)
            case .centerY:
                constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: tView.superview, attribute: .centerY,  multiplier: 1, constant: value)
            default:
                let _ = 1
            }
            return activate(constraint: constraint, identifier: "id__margin_value_\(property)", priority: priority)
        }
        else {
            switch property {
            case .height:
                tView.heightAnchor.constraint(equalToConstant: value).isActive = true
            case .width:
                tView.widthAnchor.constraint(equalToConstant: value).isActive = true
            default:
                let _ = 1
            }
            return nil
        }
    }
    
    @discardableResult
    func setHeight(_ value:CGFloat, priority:UILayoutPriority=defautPriority()) -> NSLayoutConstraint? { return setValue(value, for: .height) }
    @discardableResult
    func setWidth(_ value:CGFloat, priority:UILayoutPriority=defautPriority()) -> NSLayoutConstraint? { return setValue(value, for: .width) }
    
    func setMarginFromSuper(top:CGFloat, bottom:CGFloat, left:CGFloat, right:CGFloat, priority:UILayoutPriority=defautPriority()) {
        self.setMargin(top,    on: .top, priority:priority)
        self.setMargin(bottom, on: .bottom, priority:priority)
        self.setMargin(left,   on: .left, priority:priority)
        self.setMargin(right,  on: .right, priority:priority)
    }
                   
    @discardableResult
    func setCenter(_ center:CGPoint, priority:UILayoutPriority=defautPriority(), contentView:UIView) -> [NSLayoutConstraint?] {
        let c1 = setValue(center.x, for: .centerX)
        let c2 = setValue(center.y, for: .centerY)
        return [c1, c2]
    }
    
    // MARK: Compostos
    @discardableResult
    func setSize(_ size:CGSize, priority:UILayoutPriority=defautPriority()) -> [NSLayoutConstraint?] {
        let c1 = setValue(size.width, for: .width)
        let c2 = setValue(size.height, for: .height)
        return [c1, c2]
    }
    
    
}
