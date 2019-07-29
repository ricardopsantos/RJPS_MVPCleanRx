//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit


extension RJSLib {
    
    ////////////////////////////////////////////////////////////////
    //
    //                      NSUserDefaults
    //
    ////////////////////////////////////////////////////////////////
    
    public struct  Storages {
        private init() {}

        // MARK: - Files
        
        ////////////////////////////////////////////////////////////////
        //
        //                      Files
        //
        ////////////////////////////////////////////////////////////////
        
        
        public struct Files {
            private init() {}

            public enum Folder: Int { case documents, temp }
            
            public static func folderFrom(_ folder:Folder) -> String {
                var destenyFolder : String = ""
                switch (folder) {
                case Folder.documents:
                    destenyFolder = getDocumentsDirectory() as String
                    break
                case Folder.temp:
                    destenyFolder = getTempDirectory() as String
                    break
                }
                return destenyFolder
            }
            
            public static func getDocumentsDirectory() -> String {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = paths[0]
                return documentsDirectory as String
            }
            
            public static func getTempDirectory() -> String {
                return NSTemporaryDirectory() as String
            }
            
            public static func imageWith(name:String, folder:Folder = .documents) -> UIImage? {
                guard !name.isEmpty else { return nil }
                let destenyFolder = self.folderFrom(folder)
                var path          = "\(destenyFolder)/\(name)"
                path              = path.replace("\\", with: "/")
                if let result   = UIImage(contentsOfFile: path) {
                    return result
                }
                RJSLib.Logs.DLogWarning("Error getting image \(path) from file system")
                return nil
            }
            
            public static func saveImageWith(name:String, folder:Folder = .documents, image:UIImage) -> Bool {
                guard !name.isEmpty else { return false }
                
                let destenyFolder = self.folderFrom(folder)
                var path          = "\(destenyFolder)/\(name)"
                path              = path.replace("\\", with: "/")
                
                var sucess = false
                if let data = image.pngData() {
                    sucess = (try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
                }
                else {
                    RJSLib.Logs.DLogError("Error saving image \(path)" as AnyObject)
                }
                if(!sucess) {
                    RJSLib.Logs.DLogError("Error saving image \(path)" as AnyObject)
                }
                return sucess
            }
        
            public static func fileNamesInFolder(_ folder:Folder=Folder.documents) -> [String] {
                let destenyFolder = self.folderFrom(folder)
                
                let fileManager = FileManager.default
                do {
                    var filePaths = try fileManager.contentsOfDirectory(atPath: destenyFolder as String)
                    if(filePaths.count>0 && filePaths[0].hasPrefix("com.apple")) {
                        filePaths.remove(at: 0)
                    }
                    return filePaths
                } catch {
                    RJSLib.Logs.DLogError("\(error)" as AnyObject)
                }
                return []
            }
        
            public static func clearFolder(_ folder:Folder=Folder.documents) -> Void {
                let destenyFolder = self.folderFrom(folder)
                let filePaths = fileNamesInFolder(folder)
                for filePath in filePaths {
                    deleteFile("\(destenyFolder)/\(filePath)")
                }
            }
            
            public static func deleteFile(_ fileFullPath:String, log:Bool=false) -> Void {
                let fileManager = FileManager.default
                do {
                    try fileManager.removeItem(atPath: fileFullPath)
                }
                catch {
                    if(log) {
                        RJSLib.Logs.DLogError("\(error)" as AnyObject)
                    }
                }
            }
            
            public static func deleteFile(_ fileName:String, folder:Folder) -> Void {
                let destenyFolder = self.folderFrom(folder)
                var path          = "\(destenyFolder)/\(fileName)"
                path              = path.replace("\\", with: "/")
                deleteFile(path)
            }
            
            @discardableResult public static func appendToFile(_ fileName:String, toAppend:String, folder:Folder=Folder.documents, overWrite:Bool) -> Bool {
                let destenyFolder = self.folderFrom(folder)
                var path          = "\(destenyFolder)/\(fileName)"
                path              = path.replace("\\", with: "/")
                do {
                    if(overWrite) {
                        self.deleteFile(path)
                    }
                    try toAppend.write(toFile: path, atomically:true, encoding:String.Encoding.utf8)
                }
                catch {
                    RJSLib.Logs.DLogError("\(error)" as AnyObject)
                    return false
                }
                return true
            }
            
            @discardableResult public static func readContentOfFile(_ fileName:String, folder:Folder=Folder.documents) -> String? {
                let destenyFolder = self.folderFrom(folder)
                var path          = "\(destenyFolder)/\(fileName)"
                path              = path.replace("\\", with: "/")
                do {
                    return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                } catch {
                    return ""
                }
            }
            
            @discardableResult public static func readContentOfFileInBundle(_ fileName:String) -> String? {
                if let filepath = Bundle.main.path(forResource: fileName, ofType: "") {
                    do {
                        let contents = try String(contentsOfFile: filepath)
                        return contents
                    }
                    catch {
                        RJSLib.Logs.DLogError("\(error)" as AnyObject)
                        return nil
                    }
                } else {
                    return nil
                }
            }
            
        }

        public struct Cache {
            private init() {}

            private static var _inwStoragesCache = NSCache<NSString, AnyObject>()
            public static func add(color:AnyObject, withKey:String) -> Void {
                _inwStoragesCache.setObject(color, forKey: withKey as NSString)
            }
            public static func get(key:String) -> AnyObject? {
                if let object = _inwStoragesCache.object(forKey: key as NSString) {
                    return object
                }
                return nil
            }
            public static func clean() -> Void {
                _inwStoragesCache.removeAllObjects()
            }
        }
        
        // MARK: - UserDefaults
        
        public struct NSUserDefaults {
            private init() {}

            public static func deleteWith(key:String) -> Void {
                guard !key.isEmpty else {
                    return
                }
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey:key)
                defaults.synchronize()
                RJSLib.Utils.ASSERT_TRUE(getWith(key) == nil, message:"Falha a apagar dos defaults [\(key)]")
            }
            
            public static func save(_ objectToSave:AnyObject?, key:String) -> Void {
                guard !key.isEmpty else {
                    return
                }
                
                if(objectToSave == nil) {
                    deleteWith(key: key)
                    return
                }
                
                let defaults = UserDefaults.standard
                let dataVal : Data = NSKeyedArchiver.archivedData(withRootObject: objectToSave!)
                defaults.set(dataVal, forKey: key)
                defaults.synchronize()
                RJSLib.Utils.ASSERT_TRUE(getWith(key) != nil, message: "Falha a escrever nos defaults?")
            }
            
            @discardableResult public static func existsWith(_ key:String?) -> Bool {
                return UserDefaults.standard.object(forKey: key!) != nil
            }
            
            @discardableResult public static func getWith(_ key:String) -> AnyObject? {
                guard !key.isEmpty else { return nil }
                let defaults = UserDefaults.standard
                if let object = defaults.object(forKey: key) {
                    if let nsdata = object as? Data {
                        let result = NSKeyedUnarchiver.unarchiveObject(with: nsdata)
                        return result as AnyObject
                    }
                    else {
                        return object as AnyObject
                    }
                }
                return nil
            }
        }

        
        public struct NSUserDefaults_StoredVarUtils {
            private init() {}

            @discardableResult public static func getIntWithKey(_ key:String) -> Int {
                let value = Storages.NSUserDefaults.getWith(key)
                if(value != nil) {
                    return RJSLib.Convert.toInt(value)
                }
                else {
                    return 0
                }
            }
            
            @discardableResult public static func setIntWithKey(_ key:String, value:Int) -> Int {
                Storages.NSUserDefaults.save("\(value)" as AnyObject, key: key)
                return getIntWithKey(key)
            }
            
            @discardableResult public static func incrementIntWithKey(_ key:String) -> Int {
                let stored = getIntWithKey(key)
                Storages.NSUserDefaults.save("\(stored+1)" as AnyObject, key:key)
                return getIntWithKey(key)
            }
            
            @discardableResult public static func decrementIntWithKey(_ key:String) -> Int {
                let stored = getIntWithKey(key)
                Storages.NSUserDefaults.save("\(stored-1)" as AnyObject, key:key)
                return getIntWithKey(key)
            }
            
        }
        
    }
    
    // MARK: - Keychain
    
    public struct Keychain {
        private init() {}

        public static func saveToKeychain(_ value : String?, key : String) -> Void {
            guard !key.isEmpty else {
                RJSLib.Logs.DLogWarning("Ignored. Invalid key")
                return
            }
            guard value != nil else {
                KeychainWrapper.standard.removeObject(forKey: key)
                return
            }
            let sucess = KeychainWrapper.standard.set(value!, forKey: key)
            if(!sucess) {
                RJSLib.Utils.ASSERT_TRUE(false, message: "Falha a salvar na keychain [\(key)]=[\(value!)]")
            }
            else {
                if let result = KeychainWrapper.standard.string(forKey: key) {
                    if("\(value!)" != "\(result)") {
                        RJSLib.Utils.ASSERT_TRUE(false, message: "Falha a salvar na keychain [\(key)]=[\(value!)]")
                    }
                }
            }
        }
        
        @discardableResult public static func readFromKeychain(_ key : String, ifNilResult:String?="") -> String? {
            guard !key.isEmpty else {
                RJSLib.Logs.DLogWarning("Ignored. Invalid key")
                return nil
            }
            if let result = KeychainWrapper.standard.string(forKey: key) {
                return result
            }
            return ifNilResult
        }
        
        public static func deleteFromKeychain(_ key : String) -> Void {
            saveToKeychain(nil, key: key)
        }
        
    }

}

