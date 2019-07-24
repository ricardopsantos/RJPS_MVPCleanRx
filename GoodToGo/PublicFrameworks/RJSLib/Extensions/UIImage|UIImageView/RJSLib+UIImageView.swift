//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLibExtension where Target == UIImageView {
    
    func toGreyScale() -> Void {
        guard self.target.image != nil else {
            return
        }
        let filter  = CIFilter(name: "CIPhotoEffectMono")
        let ciInput = CIImage(image: self.target.image!)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput   = filter?.outputImage
        let ciContext  = CIContext()
        if let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!) {
            self.target.image = UIImage(cgImage: cgImage)
        }
    }

}
