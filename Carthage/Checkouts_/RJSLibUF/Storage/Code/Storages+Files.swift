//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJSLibUFBase

public extension RJSLib.Storages {
    private init() {}
    
    struct Files {
        private init() {}
        
        public enum Folder: Int { case documents, temp }
        
        public static func folderFrom(_ folder: Folder) -> String {
            switch folder {
            case .documents: return documentsDirectory
            case .temp: return tempDirectory
            }
        }
        
        public static var documentsDirectory: String {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            return documentsDirectory as String
        }
        
        public static var tempDirectory: String {
            return NSTemporaryDirectory() as String
        }
        
        public static func imageWith(name: String, folder: Folder = .documents) -> UIImage? {
            guard !name.isEmpty else { return nil }
            let destinyFolder = self.folderFrom(folder)
            var path          = "\(destinyFolder)/\(name)"
            path              = path.replacingOccurrences(of: "\\", with: "/")
            if let result   = UIImage(contentsOfFile: path) {
                return result
            }
            return nil
        }
        
        public static func saveImageWith(name: String, folder: Folder = .documents, image: UIImage) -> Bool {
            guard !name.isEmpty else { return false }
            
            let destinyFolder = self.folderFrom(folder)
            var path          = "\(destinyFolder)/\(name)"
            path              = path.replacingOccurrences(of: "\\", with: "/")

            var success = false
            if let data = image.pngData() {
                success = (try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
            }
            if !success {
               assertionFailure("Error saving image \(path)")
            }
            return success
        }
        
        public static func fileNamesInFolder(_ folder: Folder=Folder.documents) -> [String] {
            let destinyFolder = self.folderFrom(folder)
            
            let fileManager = FileManager.default
            do {
                var filePaths = try fileManager.contentsOfDirectory(atPath: destinyFolder as String)
                if filePaths.count>0 && filePaths[0].hasPrefix("com.apple") {
                    filePaths.remove(at: 0)
                }
                return filePaths
            } catch {
                assertionFailure("\(error)")
            }
            return []
        }
        
        public static func clearFolder(_ folder: Folder = .documents) {
            let destinyFolder = self.folderFrom(folder)
            let filePaths = fileNamesInFolder(folder)
            for filePath in filePaths {
                deleteFile("\(destinyFolder)/\(filePath)")
            }
        }
        
        public static func deleteFile(_ fileFullPath: String) {
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: fileFullPath)
            } catch { }
        }
        
        public static func deleteFile(_ fileName: String, folder: Folder) {
            let destinyFolder = self.folderFrom(folder)
            var path          = "\(destinyFolder)/\(fileName)"
            path              = path.replacingOccurrences(of: "\\", with: "/")
            deleteFile(path)
        }
        
        @discardableResult public static func appendToFile(_ fileName: String, toAppend: String, folder: Folder = .documents, overWrite: Bool) -> Bool {
            let destinyFolder = self.folderFrom(folder)
            var path          = "\(destinyFolder)/\(fileName)"
            path              = path.replacingOccurrences(of: "\\", with: "/")
            do {
                if overWrite {
                    self.deleteFile(path)
                }
                let finalContent = readContentOfFile(fileName, folder: folder)! + "\(toAppend)"
                try finalContent.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                assertionFailure("\(error)")
                return false
            }
            return true
        }
        
        @discardableResult public static func readContentOfFile(_ fileName: String, folder: Folder=Folder.documents) -> String? {
            let destinyFolder = self.folderFrom(folder)
            var path          = "\(destinyFolder)/\(fileName)"
            path              = path.replacingOccurrences(of: "\\", with: "/")
            do {
                return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch {
                return ""
            }
        }
        
        @discardableResult public static func readContentOfFileInBundle(_ fileName: String) -> String? {
            if let filepath = Bundle.main.path(forResource: fileName, ofType: "") {
                do {
                    return try String(contentsOfFile: filepath)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        }
        
    }
}
