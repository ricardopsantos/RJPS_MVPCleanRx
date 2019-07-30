//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLib {
    
    public struct HttpRequestsManager {
        
        private init() {}

        enum ImagesDownloadCachePolicy : Int {
            case none       = 1
            case fileSystem = 2
            case nsCache    = 3
        }
        
        private static var _imagesCache = NSCache<NSString, UIImage>()
        private static var _imageDownloadRequests : [String] = []
        static func downloadImageFrom(_ imageURL:String, caching:ImagesDownloadCachePolicy = .nsCache, completion:@escaping ((UIImage?, Bool) -> Void)) {
            
            guard !imageURL.isEmpty else {
                completion(nil, false)
                return
            }
            let cachedImageName = "cached_image_" + imageURL.toBase64().replace("=", with: "") + ".png"
            if(caching == .fileSystem) {
                
                if let cachedImage = Storages.Files.imageWith(name: cachedImageName) {
                    completion(cachedImage, true)
                    return
                }
            }
            else if (caching == .nsCache) {
                if let cachedImage = _imagesCache.object(forKey: cachedImageName as NSString) {
                    completion(cachedImage, true)
                    return
                }
            }
            
            if(_imageDownloadRequests.contains(imageURL)) {
                DispatchQueue.rjs.executeWithDelay(tread: .main, delay: 0.5) {
                    downloadImageFrom(imageURL, completion: { (image, sucess) in
                        completion(image, sucess)
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
                    DispatchQueue.rjs.inMainTread {
                        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil
                            else {
                                completion(nil, false)
                                return
                        }
                        if let image = UIImage(data: data) {
                            completion(image, true)
                            if(caching == .fileSystem) {
                                _ = Storages.Files.saveImageWith(name: cachedImageName, image: image)
                            }
                            else if(caching == .nsCache) {
                                _imagesCache.setObject(image, forKey: cachedImageName as NSString)
                            }
                        }
                        else {
                            completion(nil, false)
                        }
                    }
                    }.resume()
            }
        }
        
        //this function is fetching the json from URL
        static func dataFrom(urlString:String, completion:@escaping ((Data?, Bool) -> Void)) {
            guard let url = URL(string: urlString) else {
                RJSLib.Logs.DLogError("Invalid url : \(urlString)")
                completion(nil, false)
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                guard let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
                    let data = data,
                    error == nil
                    else {
                        RJSLib.Logs.DLogError(error)
                        DispatchQueue.rjs.inMainTread { completion(nil, false) }
                        return
                }
                DispatchQueue.rjs.inMainTread { completion(data, true) }
            }).resume()
        }
        
        // Returns in sucess, Dictionary<String, Any> or [Dictionary<String, Any>]
        static func jsonFrom(urlString:String, completion:@escaping ((AnyObject?, Bool) -> Void)) {
            dataFrom(urlString: urlString) { (data, sucess) in
                guard sucess else {
                    completion(nil, sucess)
                    return
                }
                if let object = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let json = object as? Dictionary<String, Any> { completion(json as AnyObject, true) }
                    else if let jsonArray = object as? [Dictionary<String, Any>] { completion(jsonArray as AnyObject, true) }
                    else { completion(nil, false) }
                }
                else { completion(nil, false) }
            }
        }
    }

}




