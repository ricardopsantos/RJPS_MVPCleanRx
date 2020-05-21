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

        #warning("adicionar isto ao ecran de debug")
        
        private init() {}

        private struct V1 {
            public enum Size: CGFloat {
                case big        = 24 // Heading
                case regularBig = 18 // Paragraph
                case regular    = 12 // caption
                case small      = 10
            }

            public static let bold    = Self.bold(size: .regular)
            public static let regular = Self.regular(size: .regular)
            public static let light   = Self.light(size: .regular)

            public static func bold(size: Size) -> UIFont { return UIFont(name: "HelveticaNeue-Medium", size: size.rawValue)! }
            public static func regular(size: Size) -> UIFont { return UIFont(name: "HelveticaNeue", size: size.rawValue)! }
            public static func light(size: Size) -> UIFont { return UIFont(name: "HelveticaNeue-Thin", size: size.rawValue)! }
        }

        public enum Alternative: CaseIterable {
            public typealias RawValue = UIFont

            case headingJumbo
            case headingBold
            case headingMedium
            case headingSmall
            //case paragraphBoldSecondary
            case paragraphBold
            //case paragraphMediumSecondary
            case paragraphMedium
            //case paragraphSmallSecondary
            case paragraphSmall
            //case captionLargeSecondary
            case captionLarge
            //case captionSecondary
            case caption // Same as [textStyle]
            //case captionSmallSecondary
            case captionSmall
            //case text // Same as [caption]

            public init?(rawValue: RawValue) { return nil }

            public var rawValue: RawValue {
                //let boldFontName    = "Gloriola-Bold"    // Bold
                //let mediumFontName  = "Gloriola-Medium"  // Regular/Bold
                //let regularFontName = "Gloriola-Regular" // Regular

                let boldFontName    = UIFont.App.V1.bold.fontName     // Bold
                let mediumFontName  = UIFont.App.V1.regular.fontName  // Regular/Bold
                let regularFontName = UIFont.App.V1.light.fontName    // Regular

                switch self {
                //case .text: return UIFont(name: regularFontName, size: 14.0)!
                case .headingJumbo: return UIFont(name: regularFontName, size: 38.0)!
                case .headingBold: return UIFont(name: boldFontName, size: 28.0)!
                case .headingMedium:  return UIFont(name: mediumFontName, size: 28.0)!
                case .headingSmall: return UIFont(name: regularFontName, size: 24.0)!
                //case .paragraphBoldSecondary: return UIFont(name: mediumFontName, size: 18.0)!
                case .paragraphBold:  return UIFont(name: mediumFontName, size: 18.0)!
                //case .paragraphMediumSecondary:return UIFont(name: mediumFontName, size: 16.0)!
                case .paragraphMedium: return UIFont(name: mediumFontName, size: 16.0)!
                //case .paragraphSmallSecondary: return UIFont(name: regularFontName, size: 16.0)!
                case .paragraphSmall: return UIFont(name: regularFontName, size: 16.0)!
                //case .captionLargeSecondary: return UIFont(name: regularFontName, size: 14.0)!
                case .captionLarge: return UIFont(name: regularFontName, size: 14.0)!
                //case .captionSecondary: return UIFont(name: mediumFontName, size: 12.0)!
                case .caption: return UIFont(name: mediumFontName, size: 12.0)!
                //case .captionSmallSecondary: return UIFont(name: mediumFontName, size: 10.0)!
                case .captionSmall: return UIFont(name: mediumFontName, size: 10.0)!
                }
            }
        }
    }
}
