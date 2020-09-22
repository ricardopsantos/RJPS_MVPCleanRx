//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

public extension UIFont {
    struct RJS_Fonts {

        static var bold: String = "HelveticaNeue-Medium"
        static var regular: String = "HelveticaNeue"
        static var light: String = "HelveticaNeue-Thin"

        init(bold: String="HelveticaNeue-Medium", regular: String="HelveticaNeue", light: String="HelveticaNeue") {
            Self.bold = bold
            Self.regular = regular
            Self.light = light
        }

        private struct StylesBuilder {
            public enum Size: CGFloat {
                case big        = 24 // Heading
                case regularBig = 18 // Paragraph
                case regular    = 12 // caption
                case small      = 10
            }

            public static let bold    = Self.bold(size: .regular)
            public static let regular = Self.regular(size: .regular)
            public static let light   = Self.light(size: .regular)

            public static func bold(size: Size) -> UIFont { return UIFont(name: RJS_Fonts.bold, size: size.rawValue)! }
            public static func regular(size: Size) -> UIFont { return UIFont(name: RJS_Fonts.regular, size: size.rawValue)! }
            public static func light(size: Size) -> UIFont { return UIFont(name: RJS_Fonts.light, size: size.rawValue)! }
        }

        // Find better name
        public enum Styles: CaseIterable {
            public typealias RawValue = UIFont

            case headingJumbo
            case headingBold
            case headingMedium
            case headingSmall
            case paragraphBold
            case paragraphMedium
            case paragraphSmall
            case captionLarge
            case caption
            case captionSmall

            public init?(rawValue: RawValue) { return nil }

            public var rawValue: RawValue {
                let boldFontName    = RJS_Fonts.StylesBuilder.bold.fontName     // Bold
                let mediumFontName  = RJS_Fonts.StylesBuilder.regular.fontName  // Regular/Bold
                let regularFontName = RJS_Fonts.StylesBuilder.light.fontName    // Regular
                switch self {
                case .headingJumbo: return UIFont(name: regularFontName, size: 38.0)!
                case .headingBold: return UIFont(name: boldFontName, size: 28.0)!
                case .headingMedium:  return UIFont(name: mediumFontName, size: 28.0)!
                case .headingSmall: return UIFont(name: regularFontName, size: 24.0)!
                case .paragraphBold:  return UIFont(name: mediumFontName, size: 18.0)!
                case .paragraphMedium: return UIFont(name: mediumFontName, size: 16.0)!
                case .paragraphSmall: return UIFont(name: regularFontName, size: 16.0)!
                case .captionLarge: return UIFont(name: regularFontName, size: 14.0)!
                case .caption: return UIFont(name: mediumFontName, size: 12.0)!
                case .captionSmall: return UIFont(name: mediumFontName, size: 10.0)!
                }
            }
        }
    }
}
