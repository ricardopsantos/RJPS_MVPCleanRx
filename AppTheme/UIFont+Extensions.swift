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

            public static func bold(size: Size) -> UIFont { return UIFont(name: "HelveticaNeue-Medium", size: size.rawValue)! }
            public static func regular(size: Size) -> UIFont { return UIFont(name: "HelveticaNeue", size: size.rawValue)! }
            public static func light(size: Size) -> UIFont { return UIFont(name: "HelveticaNeue-Thin", size: size.rawValue)! }
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
                //let boldFontName    = "Gloriola-Bold"    // Bold
                //let mediumFontName  = "Gloriola-Medium"  // Regular/Bold
                //let regularFontName = "Gloriola-Regular" // Regular

                let boldFontName    = UIFont.App.StylesBuilder.bold.fontName     // Bold
                let mediumFontName  = UIFont.App.StylesBuilder.regular.fontName  // Regular/Bold
                let regularFontName = UIFont.App.StylesBuilder.light.fontName    // Regular

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
