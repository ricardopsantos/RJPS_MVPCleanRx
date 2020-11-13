//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension RJSLibExtension where Target == UIImageView {
    func toGreyScale() { self.target.toGreyScale() }
}

public extension UIImageView {

    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

    func toGreyScale() {
        guard self.image != nil else { return }
        let filter  = CIFilter(name: "CIPhotoEffectMono")
        let ciInput = CIImage(image: self.image!)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput   = filter?.outputImage
        let ciContext  = CIContext()
        if let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!) {
            self.image = UIImage(cgImage: cgImage)
        }
    }
}
