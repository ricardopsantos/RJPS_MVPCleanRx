//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLibExtension where Target == UIImage {
    var grayScale: UIImage? { return self.target.grayScale }
}

public extension UIImage {

     var grayScale: UIImage? {
        guard
            let ciImage: CIImage = CIImage(image: self),
            let colorFilter: CIFilter = CIFilter(name: "CIColorControls") else {
            return nil
        }

        colorFilter.setValue(ciImage, forKey: kCIInputImageKey)
        colorFilter.setValue(0.0, forKey: kCIInputBrightnessKey)
        colorFilter.setValue(0.0, forKey: kCIInputSaturationKey)
        colorFilter.setValue(1.1, forKey: kCIInputContrastKey)

        guard
            let intermediateImage: CIImage = colorFilter.outputImage,
            let exposureFilter: CIFilter = CIFilter(name: "CIExposureAdjust") else {
                return nil
        }

        exposureFilter.setValue(intermediateImage, forKey: kCIInputImageKey)
        exposureFilter.setValue(0.7, forKey: kCIInputEVKey)
        guard let output = exposureFilter.outputImage else { return nil }

        let context: CIContext = CIContext(options: nil)
        guard let cgImage: CGImage = context.createCGImage(output, from: output.extent) else { return nil }

        let image: UIImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        return image
    }

    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
