//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation
import UIKit

extension RJSLib {
    
    public struct BasicNetworkClient {
        
        private init() {}

        public enum ImagesDownloadCachePolicy: Int {
            case none
            case cold
            case hot
            case hotOrCold
        }

        private static var _imagesCache = NSCache<NSString, UIImage>()
        public static func downloadImageFrom(_ imageURL: String, caching: ImagesDownloadCachePolicy = .hot, completion: @escaping ((UIImage?) -> Void)) {

            func returnImage(_ image: UIImage?) {
                DispatchQueue.main.async { completion(image) }
            }
            guard let url = URL(string: imageURL) else {
                returnImage(nil)
                return
            }
            let cachedImageName = "cached_image_" + Data(imageURL.utf8).base64EncodedString().self.replacingOccurrences(of: "=", with: "") + ".png"
            if (caching == .hot || caching == .hotOrCold), let cachedImage = _imagesCache.object(forKey: cachedImageName as NSString) {
                // Try hot cache first, is faster
                returnImage(cachedImage)
                return
            } else if (caching == .cold || caching == .hotOrCold), let cachedImage = BasicNetworkClientFileManager.imageWith(name: cachedImageName) {
                returnImage(cachedImage)
                return
            } else

            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                returnImage(image)
                if caching == .cold || caching == .hotOrCold {
                    _ = BasicNetworkClientFileManager.saveImageWith(name: cachedImageName, image: image)
                }
                if caching == .hot || caching == .hotOrCold {
                    _imagesCache.setObject(image, forKey: cachedImageName as NSString)
                }
            }
        }
        
        /// this function is fetching the json from URL
        public static func getDataFrom(urlString: String, completion:@escaping ((Data?, Bool) -> Void)) {
            guard let url = URL(string: urlString) else {
                assertionFailure("Invalid url : \(urlString)")
                completion(nil, false)
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                guard let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
                    let data = data,
                    error == nil
                    else {
                        assertionFailure("\(String(describing: error))")
                        DispatchQueue.main.async { completion(nil, false) }
                        return
                }
                DispatchQueue.main.async { completion(data, true) }
            }).resume()
        }
        
        /// Returns in success, Dictionary<String, Any> or [Dictionary<String, Any>]
        public static func getJSONFrom(urlString: String, completion: @escaping ((AnyObject?, Bool) -> Void)) {
            getDataFrom(urlString: urlString) { (data, success) in
                guard success else {
                    completion(nil, success)
                    return
                }
                if let object = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let json = object as? [String: Any] {
                        completion(json as AnyObject, true)
                    } else if let jsonArray = object as? [[String: Any]] {
                        completion(jsonArray as AnyObject, true)
                    } else { completion(nil, false) }
                } else { completion(nil, false) }
            }
        }
    }
}

fileprivate extension RJSLib.BasicNetworkClient {

    struct BasicNetworkClientFileManager {
        static var destinyFolder: String {
            let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            return documentsDirectory as String
        }

        static func imageWith(name: String) -> UIImage? {
            guard !name.isEmpty else { return nil }
            let path = destinyFolder + "/" + name.replacingOccurrences(of: "\\", with: "/")
            return UIImage(contentsOfFile: path)
        }

        static func saveImageWith(name: String, image: UIImage) -> Bool {
            guard !name.isEmpty else { return false }
            let path = destinyFolder + "/" + name.replacingOccurrences(of: "\\", with: "/")
            if let data = image.pngData() {
                return (try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
            }
            return false
        }
    }
}
