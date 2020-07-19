//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

//swiftlint:disable rule_UIColor_2 rule_UIColor_3

import UIKit
import Foundation
//
public extension UIColor {

    struct App {
        private init() {}

        public struct TopBar {
            private init() {}
            public static var background: UIColor { return ColorName.primary.color }
            public static var titleColor: UIColor { return ColorName.onPrimary.color }
        }

        public struct UIButton {
            public static var backgroundColorInnGage: UIColor { return UIColor.Pack1.grey_6.color }
            public static var textColorInnGage: UIColor { return UIColor.Pack1.grey_1.color }
            public static var backgroundColorDefault: UIColor { return  ColorName.primary.color }
            public static var textColorDefault: UIColor { return  ColorName.onPrimary.color }
        }

        public struct UILabel {
            public static var lblBackgroundColor: UIColor { return UIColor.Pack1.grey_6.color }
            public static var lblTextColor: UIColor { return UIColor.Pack1.grey_1.color }
        }

        public static var backgroundColor: UIColor { return ColorName.onPrimary.color }

        public static var primary: UIColor { return ColorName.primary.color }
        public static var onPrimary: UIColor { return ColorName.onPrimary.color }

        public static var error: UIColor { return ColorName.danger.color }
        public static var success: UIColor { return ColorName.success.color }
        public static var warning: UIColor { return ColorName.warning.color }

        public static var accept: UIColor { return ColorName.success.color }
        public static var reject: UIColor { return ColorName.warning.color }
        public static var remind: UIColor { return ColorName.danger.color }

    }
}

// MARK: - Color Set 1

public extension UIColor {

    enum Pack1: CaseIterable {
        public typealias RawValue = UIColor
        public init?(rawValue: RawValue) { return nil }
        public var color: UIColor { return self.rawValue }

        case grey_1
        case grey_2
        case grey_3
        case grey_5
        case grey_6
        case grey_7
        case red1
        case blue1
        case blue2
        case orange

        public var rawValue: RawValue {
            switch self {
            case .grey_1: return UIColor.colorFromRGBString("91,92,123")
            case .grey_2: return UIColor.colorFromRGBString("127,128,153")
            case .grey_3: return UIColor.colorFromRGBString("151,155,176")
            case .grey_5: return UIColor.colorFromRGBString("221,225,233")
            case .grey_6: return UIColor.colorFromRGBString("235,238,243")
            case .grey_7: return UIColor.colorFromRGBString("244,246,250")
            case .red1:   return UIColor.colorFromRGBString("255,100,100")
            case .blue1:  return UIColor.colorFromRGBString("10,173,175")
            case .blue2:  return UIColor.colorFromRGBString("148,208,187")
            case .orange: return UIColor(red: 242, green: 168, blue: 62)
            }
        }
    }
}

// MARK: - Color Set 2

public extension UIColor {

    enum Pack2: CaseIterable {
        public typealias RawValue = UIColor
        public init?(rawValue: RawValue) { return nil }
        public var color: UIColor { return self.rawValue }

        case white
        case dirtyWhite
        case lightGray
        case silver
        case gray
        case darkSilver
        case darkGray
        case charcoal
        case obsidian
        case black
        case glacier
        case lightBlue
        case cerulean
        case brightTurquoise
        case easternBlue
        case sanMarino
        case sanJuan
        case neonBlue
        case darkBlue
        case persianPurple
        case dodgerBlue
        case fuchsiaBlue
        case purple
        case seance
        case mulberry
        case red
        case razzmatazz
        case spicyMix
        case clementine
        case carrotOrange
        case ochre
        case orange
        case butterCup
        case yellow
        case roti
        case celery
        case caribbeanGreen
        case green
        case dustyGray

        public var rawValue: RawValue {
            switch self {
            case .white: return UIColor(white: 1.0, alpha: 1.0)
            case .dirtyWhite: return UIColor(white: 250.0 / 255.0, alpha: 1.0)
            case .lightGray: return UIColor(red: 231.0 / 255.0, green: 235.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
            case .silver: return UIColor(red: 187.0 / 255.0, green: 195.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
            case .gray:  return UIColor(red: 132.0 / 255.0, green: 152.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
            case .darkSilver: return UIColor(red: 70.0 / 255.0, green: 85.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
            case .darkGray: return UIColor(red: 53.0 / 255.0, green: 57.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
            case .charcoal:  return UIColor(red: 33.0 / 255.0, green: 47.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
            case .obsidian:  return UIColor(red: 22.0 / 255.0, green: 30.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
            case .black: return UIColor(white: 0.0, alpha: 1.0)
            case .glacier: return UIColor(red: 125.0 / 255.0, green: 164.0 / 255.0, blue: 193.0 / 255.0, alpha: 1.0)
            case .lightBlue: return UIColor(red: 113.0 / 255.0, green: 185.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
            case .cerulean:  return UIColor(red: 1.0 / 255.0, green: 162.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
            case .brightTurquoise:  return UIColor(red: 0.0, green: 184.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
            case .easternBlue:return UIColor(red: 31.0 / 255.0, green: 133.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0)
            case .sanMarino:return UIColor(red: 62.0 / 255.0, green: 110.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
            case .sanJuan:  return UIColor(red: 53.0 / 255.0, green: 87.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
            case .neonBlue: return UIColor(red: 42.0 / 255.0, green: 77.0 / 255.0, blue: 141.0 / 255.0, alpha: 1.0)
            case .darkBlue:return UIColor(red: 9.0 / 255.0, green: 50.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
            case .persianPurple:  return UIColor(red: 50.0 / 255.0, green: 34.0 / 255.0, blue: 160.0 / 255.0, alpha: 0.95)
            case .dodgerBlue: return UIColor(red: 83.0 / 255.0, green: 109.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
            case .fuchsiaBlue: return UIColor(red: 106.0 / 255.0, green: 81.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
            case .purple: return UIColor(red: 148.0 / 255.0, green: 94.0 / 255.0, blue: 183.0 / 255.0, alpha: 1.0)
            case .seance: return UIColor(red: 142.0 / 255.0, green: 36.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
            case .mulberry:  return UIColor(red: 199.0 / 255.0, green: 75.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
            case .red: return UIColor(red: 197.0 / 255.0, green: 51.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
            case .razzmatazz: return UIColor(red: 245.0 / 255.0, green: 0.0, blue: 87.0 / 255.0, alpha: 1.0)
            case .spicyMix: return UIColor(red: 128.0 / 255.0, green: 83.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
            case .clementine:  return UIColor(red: 239.0 / 255.0, green: 108.0 / 255.0, blue: 0.0, alpha: 1.0)
            case .carrotOrange: return UIColor(red: 242.0 / 255.0, green: 141.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
            case .ochre:  return UIColor(red: 202.0 / 255.0, green: 118.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)
            case .orange:  return UIColor(red: 232.0 / 255.0, green: 144.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
            case .butterCup:  return UIColor(red: 241.0 / 255.0, green: 177.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
            case .yellow:  return UIColor(red: 1.0, green: 206.0 / 255.0, blue: 83.0 / 255.0, alpha: 1.0)
            case .roti: return UIColor(red: 182.0 / 255.0, green: 163.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
            case .celery:return UIColor(red: 155.0 / 255.0, green: 186.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
            case .caribbeanGreen:  return UIColor(red: 0.0, green: 191.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
            case .green: return UIColor(red: 66.0 / 255.0, green: 196.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0)
            case .dustyGray: return UIColor(red: 162.0 / 255.0, green: 148.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
            }
        }

    }
}

public typealias ColorName = UIColor.Pack3
public extension UIColor {

    enum Pack3: CaseIterable {
        public typealias RawValue = UIColor
        public init?(rawValue: RawValue) { return nil }
        public var color: UIColor { return self.rawValue }

        case background
        case onBackground
        case surface
        case onSurface
        case detail
        case onDetail
        case divider
        case overlayBackground
        case void
        case onVoid
        case primary
        case onPrimary
        case primaryVariant
        case onPrimaryVariant
        case secondary
        case onSecondary
        case success
        case onSuccess
        case danger
        case onDanger
        case warning
        case onWarning

        public var rawValue: RawValue {
            let onLigthMode = true
             switch self {
             case .background: return onLigthMode ? UIColor.Pack2.dirtyWhite.color : UIColor.Pack2.obsidian.color
             case .onBackground: return onLigthMode ? UIColor.Pack2.darkBlue.color : UIColor.Pack2.white.color
             case .surface: return onLigthMode ? UIColor.Pack2.white.color  : UIColor.Pack2.charcoal.color
             case .onSurface: return onLigthMode ? UIColor.Pack2.darkBlue.color : UIColor.Pack2.white.color
             case .detail: return onLigthMode ? UIColor.Pack2.silver.color : UIColor.Pack2.darkSilver.color
             case .onDetail: return onLigthMode ?  UIColor.Pack2.white.color : UIColor.Pack2.silver.color
             case .divider: return onLigthMode ? UIColor.Pack2.lightGray.color  : UIColor.Pack2.darkGray.color
             case .overlayBackground: return UIColor.Pack2.dirtyWhite.color.withAlphaComponent(0.5)
             case .void: return UIColor.Pack2.black.color
             case .onVoid: return UIColor.Pack2.white.color
             case .primary: return UIColor.Pack2.lightBlue.color
             case .onPrimary: return UIColor.Pack2.white.color
             case .primaryVariant: return UIColor.Pack2.lightBlue.color.withAlphaComponent(0.1)
             case .onPrimaryVariant: return UIColor.Pack2.lightBlue.color
             case .secondary: return UIColor.Pack2.yellow.color
             case .onSecondary: return UIColor.Pack2.darkBlue.color
             case .success: return UIColor.Pack2.green.color
             case .onSuccess: return UIColor.Pack2.white.color
             case .danger: return UIColor.Pack2.red.color
             case .onDanger: return UIColor.Pack2.white.color
             case .warning: return UIColor.Pack2.orange.color
             case .onWarning: return UIColor.Pack2.white.color
            }
        }
    }
}
