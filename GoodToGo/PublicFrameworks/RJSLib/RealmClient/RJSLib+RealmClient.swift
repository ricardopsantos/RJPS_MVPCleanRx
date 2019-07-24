//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

//#if REALM_INSTALED
#if true

import Foundation
import RealmSwift

protocol RealmClient_Protocol: class {
    func saveObjects(objs: [Object], callback: @escaping (_ result: Result<Void>) -> Void)
    func getObjects(type: Object.Type, filter: String, callback: @escaping (_ result: Result< Results<Object>?>) -> Void)
    func getObjects(type: Object.Type) -> Results<Object>?
}

extension RJSLib {
    class RealmClient : RealmClient_Protocol {
        lazy var realm = try? Realm()
        func saveObjects(objs: [Object], callback: @escaping (Result<Void>) -> Void) {
            do {
                try realm?.write ({
                    objs.forEach({ obj in realm?.add(obj, update: false) })
                    callback(Result.success(()))
                })
            } catch let error {
                RJSLib.Logs.DLogError(error)
                callback(Result.failure(error))
            }
        }
        
        func getObjects(type: Object.Type, filter: String, callback: @escaping (Result<Results<Object>?>) -> Void) {
            do {
                try realm?.write ({
                    let result = realm!.objects(type).filter("postCode CONTAINS '\(filter)' OR localityName CONTAINS '\(filter)'")
                    callback(Result.success(result))
                })
            } catch let error {
                RJSLib.Logs.DLogError(error)
                callback(Result.failure(error))
            }
        }
        
        //Returs an array as Results<object>?
        func getObjects(type: Object.Type) -> Results<Object>? {
            return realm?.objects(type)
        }
        
    }

}

#endif
