//
//  UIFontExtestion+Heplers.swift
//

import SwiftUI

enum FontName {
    case light
    case regular
    case medium
    case semibold
    case bold
    
    var font: String {
        switch self {
        case .light:
            return "SFPro-Light"
        case .regular:
            return "SFPro-Regular"
        case .medium:
            return "SFPro-Medium"
        case .semibold:
            return "SFPro-SemiBold"
        case .bold:
            return "SFPro-Bold"
        }
    }
}



extension Font {
    static func appFontLight(_ size: CGFloat) -> Font {
        .custom(FontName.light.font, size: size)
    }
    
    static func appFontRegular(_ size: CGFloat) -> Font {
        .custom(FontName.regular.font, size: size)
    }
    
    static func appFontMedium(_ size: CGFloat) -> Font {
        .custom(FontName.medium.font, size: size)
    }
    
    static func appFontSemibold(_ size: CGFloat) -> Font {
        .custom(FontName.semibold.font, size: size)
    }
    
    static func appFontBold(_ size: CGFloat) -> Font {
        .custom(FontName.bold.font, size: size)
    }
}
