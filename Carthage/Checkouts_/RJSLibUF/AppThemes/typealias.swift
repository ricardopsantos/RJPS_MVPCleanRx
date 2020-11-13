//
//  Created by Ricardo Santos on 11/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

//
// typealias? Why?
//
// 1 : When using RJSLib on other projects, instead of using `UIFont.RJS_Fonts`, we can use `RJS_Fonts` which can be more elegant to use
// 2 : Also, when using RJSLib, we can type `RJS_` and the Xcode auto-complete feature will suggest only thing inside RJSLib
// 3 : And for last, if one day the module `UIColor.Pack1` changes name for something like `UIColor.PackGrayAndBlue`,
// the external apps using the alias wont need to change anything because the alias stays the same
//

// Pack of 10 related colors, mostly based on Greys and Blues (grey_1, grey_2, grey_3, blue1, blue2, ...)
public typealias RJS_ColorPack1 = UIColor.Pack1

// Pack of 46 unrelated colors, ranging all types os colors (dirtyWhite, lightGray, silver, charcoal, neonBlue, ...)
public typealias RJS_ColorPack2 = UIColor.Pack2

// Pack of 22 color namings, inspired on https://developer.android.com/reference/kotlin/androidx/compose/material/Colors
// Same as RJS_ColorPack3. (surface, onSurface, detail, onDetail, success, onSuccess)
public typealias RJS_ColorPack3 = UIColor.Pack3
public typealias RJS_ColorName = UIColor.Pack3

// Font styles utils with a font builder for Bold, Regular and Light, and also pre-built styles like : headingJumbo, headingBold, headingMedium, headingSmall
public typealias RJS_Fonts = UIFont.RJS_Fonts
