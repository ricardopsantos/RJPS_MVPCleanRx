//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation
import UIKit
//
import RJPSLib_Base
import RJPSLib_Storage

extension RJSLib {
    
    public struct BasicNetworkClient {
        
        private init() {}

        public enum ImagesDownloadCachePolicy: Int {
            case none
            case fileSystem
            case nsCache 
        }
        
        private static var _imagesCache = NSCache<NSString, UIImage>()
        private static var _imageDownloadRequests: [String] = []
        public static func downloadImageFrom(_ imageURL: String, caching: ImagesDownloadCachePolicy = .nsCache, completion: @escaping ((UIImage?) -> Void)) {
            
            guard !imageURL.isEmpty else {
                completion(nil)
                return
            }
            let cachedImageName = "cached_image_" + imageURL.base64Encoded.replace("=", with: "") + ".png"
            if caching == .fileSystem {
                if let cachedImage = RJS_Files.imageWith(name: cachedImageName) {
                    completion(cachedImage)
                    return
                }
            } else if caching == .nsCache {
                if let cachedImage = _imagesCache.object(forKey: cachedImageName as NSString) {
                    completion(cachedImage)
                    return
                }
            }
            
            if _imageDownloadRequests.contains(imageURL) {
                DispatchQueue.executeWithDelay(tread: .main, delay: 1) {
                    downloadImageFrom(imageURL, completion: { (image) in
                        completion(image)
                    })
                }
                return
            }
            
            if let url = URL(string: imageURL) {
                _imageDownloadRequests.append(imageURL)
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                config.urlCache = nil
                URLSession.init(configuration: config).dataTask(with: url) { (data, response, error) in
                    _imageDownloadRequests.removeObject(imageURL)
                    DispatchQueue.executeInMainTread {
                        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil
                            else {
                                completion(nil)
                                return
                        }
                        if let image = UIImage(data: data) {
                            completion(image)
                            if caching == .fileSystem {
                                _ = RJS_Files.saveImageWith(name: cachedImageName, image: image)
                            } else if caching == .nsCache {
                                _imagesCache.setObject(image, forKey: cachedImageName as NSString)
                            }
                        } else {
                            completion(nil)
                        }
                    }
                }.resume()
            }
        }
        
        /// this function is fetching the json from URL
        public static func getDataFrom(urlString: String, completion:@escaping ((Data?, Bool) -> Void)) {
            guard let url = URL(string: urlString) else {
                RJS_Logs.error("Invalid url : \(urlString)")
                completion(nil, false)
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                guard let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
                    let data = data,
                    error == nil
                    else {
                        RJS_Logs.error(error)
                        DispatchQueue.executeInMainTread { completion(nil, false) }
                        return
                }
                DispatchQueue.executeInMainTread { completion(data, true) }
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
