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

extension RJSLibExtension where Target == XCUIApplication {
    
    func resetDataOnStart() -> Void {
        self.target.launchArguments.append(AppConstants_UITests.Misc.CommandLineArguments.deleteUserData)
    }
    
    func allXCUIElementQuerys_Base() -> [XCUIElementQuery] {
        return [self.target.staticTexts, self.target.images, self.target.textFields, self.target.secureTextFields, self.target.buttons, self.target.alerts, self.target.collectionViews, self.target.maps, self.target.navigationBars, self.target.pickers, self.target.progressIndicators, self.target.scrollViews, self.target.segmentedControls, self.target.switches, self.target.tabBars, self.target.webViews, self.target.tables]
    }
    
    // Elements that can support user inputing text
    func allXCUIElementQuerys_InputFields(includeSecureFields:Bool=false) -> [XCUIElementQuery] {
        var xcUIElementQuerys = [self.target.textFields, self.target.textViews, self.target.searchFields]
        if(includeSecureFields) {
            xcUIElementQuerys.append(contentsOf: allXCUIElementQuerys_SecureFields())
        }
        return xcUIElementQuerys
    }
    
    func allXCUIElementQuerys_SecureFields() -> [XCUIElementQuery] {
        return [self.target.secureTextFields]
    }
    
    // Elements that can be pressed
    func allXCUIElementQuerys_Hittable () -> [XCUIElementQuery] {
        let xcUIElementQuerys = [self.target.buttons, self.target.tables.staticTexts, self.target.collectionViews.staticTexts, self.target.images, self.target.staticTexts, self.target.otherElements, self.target.scrollViews.otherElements.buttons, self.target.webViews.buttons]
        return xcUIElementQuerys
    }
    
    func tableCellsCount() -> Int { return self.target.tables.cells.count }
    func tapTableViewCellAt(index:Int) -> Bool {
        return self.target.tables.cells.element(boundBy: index).rjs.tapSafe()
    }
    
    func isViewWithAccessibilityIdentifier(_ identifier:String) -> Bool {
        let exists = self.target.otherElements[identifier].exists
        if(!exists) {
            DLog("Not found otherElements[\(identifier)]")
        }
        return exists
    }
    
    func tapUIAlertViewWith(_ title:String, option:String, delayTime:Double=1.5, completion:@escaping (Bool)->(Void)) -> Void {
        if(self.target.sheets[title].exists) {
            if(self.target.sheets[title].buttons[option].exists) {
                self.target.sheets[title].buttons[option].rjs.tapSafe()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: { completion(true) })
    }
    
    func tapUIElementWith(_ name:String, delayTime:Double=2, logIfNotFound:Bool=true, completion:@escaping (Bool)->(Void)) -> Void {
        var sucess = false
        let xcUIElementQuerys = allXCUIElementQuerys_Hittable()
        xcUIElementQuerys.forEach { (some) in
            if(some[name].exists && !sucess) {
                sucess = some[name].firstMatch.rjs.tapSafe()
                if(sucess) {
                    DLog("XCUIElement [\(name)] tapped")
                }
            }
        }
        
        if(!sucess) {
            if(logIfNotFound) {
                DLog("XCUIElement [\(name)] NOT FOUND (to tap)!")
            }
            completion(false)
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: {
                completion(true)
            })
        }
    }

    
    @discardableResult
    func existButtonWith(text:String) -> Bool {
        let xcUIElementQuerys = allXCUIElementQuerys_Hittable()
        return xcUIElementQuerys.filter { (some) -> Bool in some[text].exists }.count > 0
    }
    
    @discardableResult
    func existInputFieldWith(text:String) -> Bool {
        let xcUIElementQuerys = allXCUIElementQuerys_InputFields()
        let exists = xcUIElementQuerys.filter { (some) -> Bool in some[text].exists }.count > 0
        return exists
    }
    
    @discardableResult
    func existElementWith(text:String, logFail:Bool=true) -> Bool {
        let c1 = self.target.staticTexts[text].exists
        let c2 = existInputFieldWith(text: text)
        let c3 = existButtonWith(text: text)
        let c4 = self.target.images[text].exists
        var acc = "Testing existance of [\(text)] : "
        if(c1) { acc = acc + "found staticTexts" }
        else if(c2) { acc = acc + "found InputField (TextView, TextField, SearchField, etc)" }
        else if(c3) { acc = acc + "found Button" }
        else if(c4) { acc = acc + "found Image" }
        var exists = c1 || c2 || c3 || c4
        if(!exists) {
            let xcUIElementQuerys = allXCUIElementQuerys_Base()
            exists = xcUIElementQuerys.filter { (some) -> Bool in some[text].exists }.count > 0
            if(exists) { acc = acc + "found unknow element" }
        }
        if(!exists) {
            acc = acc + "Not found!"
        }
        if(logFail && !exists) {
            DLog(acc)
        }
        else if(exists) {
            DLog(acc)
        }
        return exists
    }
    
    func typeInInputFields(text:String, fieldId:String, delayTime:Double=0.3, completion:@escaping (Bool)->(Void)) -> Void {
        
        var xcUIElementQuerys : [XCUIElementQuery] = []
        let isSecure = XCUIApplication().secureTextFields[fieldId].exists
        let isOther  = XCUIApplication().otherElements[fieldId].exists
        if(isSecure) {
           xcUIElementQuerys = self.allXCUIElementQuerys_SecureFields()
        }
        else if(isOther) {
            xcUIElementQuerys = [self.target.otherElements]
        }
        else {
            xcUIElementQuerys = self.self.allXCUIElementQuerys_InputFields()
        }
        func tryWith(querys:[XCUIElementQuery]) -> Bool {
            var sucess_in = false
            querys.forEach { (some) in
                if(!sucess_in && some[fieldId].exists /*|| some.otherElements[fieldId].exists)*/) {
                    let field = some[fieldId]
                    sucess_in = field.rjs.tapSafe()
                    if(sucess_in) {
                        field.rjs.clearAndEnterText(text: text, dismissKeyboardAfter: true)
                        if(!isSecure) {
                            // We cant check if its secured
                            sucess_in = self.existElementWith(text: text)
                        }
                    }
                }
            }
            return sucess_in
        }
        
        let sucess = tryWith(querys: xcUIElementQuerys)

        if(!sucess) {
            //self.debugUI()
            DLog("Fail to type [\(text)] in some[\(fieldId)] isSecure:\(isSecure) | isOther:\(isOther)")
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: {
                completion(false)
            })
        }
        else {
            DLog("some[\(fieldId)].text = [\(text)]")
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: {
                completion(true)
            })
        }
    }
    
    private func ctpDebug(_ query:XCUIElementQuery, id:String) -> Void {
        DLog("\n# DUMP [\(id)]:")
        dump(query)
    }
    
    @discardableResult func debugUI(_ filter:String="", dumpAll:Bool=false) -> String {
        
        if(dumpAll) {
            allXCUIElementQuerys_Base().forEach { (some) in
                ctpDebug(some, id: "")
            }
            DLog(XCUIApplication().debugDescription)
        }
        
        func evalXCUIElementQuery(xcUIElementQuery:XCUIElementQuery, objectType:String) -> String {
            var acc = ""
            let extraSpace = " - "
            for i in 0...xcUIElementQuery.count {
                let ele = xcUIElementQuery.element(boundBy: i)

                if(ele.frame.size.height != 0 && ele.frame.size.width != 0) {
                    acc = "\(acc)" + extraSpace + "\(objectType).frame[\(i)] : [\(ele.frame)]" + "\n"
                }
                func shouldShow(_ value:String?) -> Bool {
                    if (value == nil) { return false }
                    return value! != "" && value! != "AX error -25205"
                }
                if(shouldShow(ele.identifier)) {
                    acc = "\(acc)" + extraSpace + "\(objectType).identifier[\(i)] : [\(ele.identifier)]" + "\n"
                }
                if(shouldShow(ele.label)) {
                    acc = "\(acc)" + extraSpace + "\(objectType).label[\(i)] : [\(ele.label)]" + "\n"
                }
                if(shouldShow(ele.title)) {
                    acc = "\(acc)" + extraSpace + "\(objectType).title[\(i)] : [\(ele.title)]" + "\n"
                }
                if(shouldShow(ele.placeholderValue)) {
                    acc = "\(acc)" + extraSpace + "\(objectType).placeholderValue[\(i)] : [\(ele.placeholderValue!)]" + "\n"
                }
            }
            return acc
        }
        
        var acc = ""
        if(filter.lowercased() == "staticTexts".lowercased() || filter == "") {
            if(self.target.staticTexts.count > 0) {
                acc = acc + "## \("static_Texts".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.staticTexts, objectType: "staticText")
            }
        }
        if(filter.lowercased() == "secureTextFields".lowercased() || filter == "") {
            if(self.target.staticTexts.count > 0) {
                acc = acc + "## \("secureTextFields".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.secureTextFields, objectType: "secureTextFields")
            }
        }
        if(filter.lowercased() == "textViews".lowercased() || filter == "") {
            if(self.target.textViews.count > 0) {
                acc = acc + "## \("text_Views".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.textViews, objectType: "textView")
            }
        }
        if(filter.lowercased() == "textFields".lowercased() || filter == "") {
            if(self.target.textFields.count > 0) {
                acc = acc + "## \("text_Fields".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.textFields, objectType: "textField")
            }
        }
        if(filter.lowercased() == "searchFields".lowercased() || filter == "") {
            if(self.target.textFields.count > 0) {
                acc = acc + "## \("search_fields".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.searchFields, objectType: "searchFields")
            }
        }
        if(filter.lowercased() == "buttons".lowercased() || filter == "") {
            if(self.target.buttons.count > 0) {
                acc = acc + "## \("buttons".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.buttons, objectType: "button")
            }
        }
        if(filter.lowercased() == "images".lowercased() || filter == "") {
            if(self.target.images.count > 0) {
                acc = acc + "## \("images".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.images, objectType: "image")
            }
        }
        if(filter.lowercased() == "otherElements".lowercased() || filter == "") {
            if(self.target.otherElements.count > 0) {
                acc = acc + "## \("other_Elements".uppercased()) ##" + "\n"
                acc = acc + evalXCUIElementQuery(xcUIElementQuery: self.target.otherElements, objectType: "otherElement")
            }
        }
        DLog(acc)
        return acc
    }
}
