//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

//
// DONT ADD / CHANGE WITHOUT ASKING THE TEAM-LEADER
//
//
// DONT ADD / CHANGE WITHOUT ASKING THE TEAM-LEADER
//
//
// DONT ADD / CHANGE WITHOUT ASKING THE TEAM-LEADER
//

import XCTest

extension RJSLibExtension where Target == XCUIElement {

    func clearText() -> Void {
        guard let stringValue = self.target.value as? String else { return }
        if let placeholderString = self.target.placeholderValue, placeholderString == stringValue { return } // workaround for apple bug
        var deleteString = String()
        for _ in stringValue { deleteString += XCUIKeyboardKey.delete.rawValue }
        self.tapSafe()
        self.target.typeText(deleteString)
    }
    
    @discardableResult
    func tapSafe(twice:Bool=false, logFail:Bool=false) -> Bool {
        func tapElementAndWaitForKeyboardToAppear(twice:Bool=false) {
            let keyboard = XCUIApplication().keyboards.element
            while (true) {
                if twice { self.target.doubleTap() }
                else { self.target.tap() }
                if keyboard.exists {
                    break
                }
                RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 0.5) as Date)
            }
        }
        if self.target.isHittable {
            if twice { self.target.doubleTap() }
            else { self.target.tap() }
            return true
        }
        let info = "[\(self.target)]"
        if logFail {
            DLog("XCUIElement [\(info)] not hitable!")
        }
        return false
    }
    
    func clearAndEnterText(text: String, dismissKeyboardAfter:Bool=true) -> Void {
        self.tapSafe(logFail: true)
        self.clearText()
        if dismissKeyboardAfter {
            self.target.typeText(text + "\n")
        }
        else {
            self.target.typeText(text)
        }
    }
}
