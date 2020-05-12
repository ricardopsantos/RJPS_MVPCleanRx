//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

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
            let destenyFolder = self.folderFrom(folder)
            var path          = "\(destenyFolder)/\(name)"
            path              = path.replace("\\", with: "/")
            if let result   = UIImage(contentsOfFile: path) {
                return result
            }
            RJS_Logs.DLogWarning("Error getting image \(path) from file system")
            return nil
        }

        public static func saveImageWith(name: String, folder: Folder = .documents, image: UIImage) -> Bool {
            guard !name.isEmpty else { return false }

            let destenyFolder = self.folderFrom(folder)
            var path          = "\(destenyFolder)/\(name)"
            path              = path.replace("\\", with: "/")

            var success = false
            if let data = image.pngData() {
                success = (try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
            }
            if !success {
                RJS_Logs.DLogError("Error saving image \(path)" as AnyObject)
            }
            return success
        }

        public static func fileNamesInFolder(_ folder: Folder=Folder.documents) -> [String] {
            let destenyFolder = self.folderFrom(folder)

            let fileManager = FileManager.default
            do {
                var filePaths = try fileManager.contentsOfDirectory(atPath: destenyFolder as String)
                if filePaths.count>0 && filePaths[0].hasPrefix("com.apple") {
                    filePaths.remove(at: 0)
                }
                return filePaths
            } catch {
                RJS_Logs.DLogError("\(error)" as AnyObject)
            }
            return []
        }

        public static func clearFolder(_ folder: Folder = .documents) {
            let destenyFolder = self.folderFrom(folder)
            let filePaths = fileNamesInFolder(folder)
            for filePath in filePaths {
                deleteFile("\(destenyFolder)/\(filePath)")
            }
        }

        public static func deleteFile(_ fileFullPath: String, log: Bool=false) {
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: fileFullPath)
            } catch {
                if log {
                    RJS_Logs.DLogError("\(error)" as AnyObject)
                }
            }
        }

        public static func deleteFile(_ fileName: String, folder: Folder) {
            let destenyFolder = self.folderFrom(folder)
            var path          = "\(destenyFolder)/\(fileName)"
            path              = path.replace("\\", with: "/")
            deleteFile(path)
        }

        @discardableResult public static func appendToFile(_ fileName: String, toAppend: String, folder: Folder = .documents, overWrite: Bool) -> Bool {
            let destenyFolder = self.folderFrom(folder)
            var path          = "\(destenyFolder)/\(fileName)"
            path              = path.replace("\\", with: "/")
            do {
                if overWrite {
                    self.deleteFile(path)
                }
                let finalContent = readContentOfFile(fileName, folder: folder)! + "\(toAppend)"
                try finalContent.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                RJS_Logs.DLogError("\(error)" as AnyObject)
                return false
            }
            return true
        }

        @discardableResult public static func readContentOfFile(_ fileName: String, folder: Folder=Folder.documents) -> String? {
            let destenyFolder = self.folderFrom(folder)
            var path          = "\(destenyFolder)/\(fileName)"
            path              = path.replace("\\", with: "/")
            do {
                return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch {
                return ""
            }
        }

        @discardableResult public static func readContentOfFileInBundle(_ fileName: String) -> String? {
            if let filepath = Bundle.main.path(forResource: fileName, ofType: "") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    return contents
                } catch {
                    RJS_Logs.DLogError("\(error)" as AnyObject)
                    return nil
                }
            } else {
                return nil
            }
        }

    }
}
