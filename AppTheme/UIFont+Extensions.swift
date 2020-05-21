//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

public extension UIFont {
    struct App {
        private init() {}
        public enum Size: CGFloat {
            case big        = 24 // Heading
            case regularBig = 18 // Paragraph
            case regular    = 12 // caption
            case small      = 10
        }
        
        public static let bold    = Self.bold(size: .regular)
        public static let regular = Self.regular(size: .regular)
        public static let light   = Self.light(size: .regular)

        public static func bold(size: Size) -> UIFont {
            return UIFont(name: "HelveticaNeue-Medium", size: size.rawValue)!
        }

        public static func regular(size: Size) -> UIFont {
            return UIFont(name: "HelveticaNeue", size: size.rawValue)!
        }

        public static func light(size: Size) -> UIFont {
            return UIFont(name: "HelveticaNeue-Thin", size: size.rawValue)!
        }
    }
}
/*
extension UIFont {

  class var textStyle: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var headingJumboCenter: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 38.0)!
  }

  class var headingJumboRight: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 38.0)!
  }

  class var headingJumboLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 38.0)!
  }

  class var headingboldCenter: UIFont {
    return UIFont(name: "Gloriola-Bold", size: 28.0)!
  }

  class var headingboldRight: UIFont {
    return UIFont(name: "Gloriola-Bold", size: 28.0)!
  }

  class var headingboldLeft: UIFont {
    return UIFont(name: "Gloriola-Bold", size: 28.0)!
  }

  class var headingMediumCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 28.0)!
  }

  class var headingMediumRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 28.0)!
  }

  class var headingMediumLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 28.0)!
  }

  class var headingSmallCenter: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 24.0)!
  }

  class var headingSmallRight: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 24.0)!
  }

  class var headingSmallLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 24.0)!
  }

  class var paragraphBoldSecondaryRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 18.0)!
  }

  class var paragraphBoldSecondaryCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 18.0)!
  }

  class var paragraphBoldCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 18.0)!
  }

  class var paragraphBoldRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 18.0)!
  }

  class var paragraphBoldSecondaryLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 18.0)!
  }

  class var paragraphBoldLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 18.0)!
  }

  class var paragraphMediumSecondaryRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 16.0)!
  }

  class var paragraphMediumSecondaryCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 16.0)!
  }

  class var paragraphMediumCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 16.0)!
  }

  class var paragraphMediumRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 16.0)!
  }

  class var paragraphMediumSecondaryLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 16.0)!
  }

  class var paragraphMediumLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 16.0)!
  }

  class var paragraphSmallSecondaryRight: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 16.0)!
  }

  class var paragraphSmallSecondaryCenter: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 16.0)!
  }

  class var paragraphSmallCenter: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 16.0)!
  }

  class var paragraphSmallRight: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 16.0)!
  }

  class var paragraphSmallSecondaryLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 16.0)!
  }

  class var paragraphSmallLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 16.0)!
  }

  class var captionLargeSecondaryRight: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var captionLargeSecondaryCenter: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var captionLargeSecondaryLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var captionLargeCaption: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var captionLargeRight: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var paragraphSmallLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var paragraphSmallLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var captionLargeSecondaryLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var captionLargeLeft: UIFont {
    return UIFont(name: "Gloriola-Regular", size: 14.0)!
  }

  class var captionSecondaryRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 12.0)!
  }

  class var captionSecondaryCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 12.0)!
  }

  class var captionSecondaryLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 12.0)!
  }

  class var captionCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 12.0)!
  }

  class var captionRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 12.0)!
  }

  class var captionSecondaryLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 12.0)!
  }

  class var captionLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 12.0)!
  }

  class var captionSmallSecondaryRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 10.0)!
  }

  class var captionSmallSecondaryCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 10.0)!
  }

  class var captionSmallSecondaryLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 10.0)!
  }

  class var captionSmallCenter: UIFont {
    return UIFont(name: "GloriolaMedium", size: 10.0)!
  }

  class var captionSmallRight: UIFont {
    return UIFont(name: "GloriolaMedium", size: 10.0)!
  }

  class var captionSmallSecondaryLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 10.0)!
  }

  class var captionSmallLeft: UIFont {
    return UIFont(name: "GloriolaMedium", size: 10.0)!
  }

}
*/
