import Foundation
import SwiftUI

extension Font {
    static var RobotoRegular: Font {
            Font.custom("Roboto-Regular", size: 20, relativeTo: .title3)
        }
    static var RobotoThinItalicTabBar: Font {
        Font.custom("Roboto-ThinItalic", size: 12, relativeTo: .subheadline)
        }
    static var RobotoThinItalicSmall: Font {
            Font.custom("Roboto-ThinItalic", size: 18, relativeTo: .title2)
        }
    static var RobotoThinItalic: Font {
            Font.custom("Roboto-ThinItalic", size: 24, relativeTo: .title2)
        }
    static var RobotoThinItalicLarge: Font {
            Font.custom("Roboto-ThinItalic", size: 48, relativeTo: .title)
        }

    static var RobotoMedium: Font {
            Font.custom("Roboto-Medium", size: 18, relativeTo: .title3)
        }
    static var RobotoMediumItalic: Font {
            Font.custom("Roboto-MediumItalic", size: 18, relativeTo: .title3)
        }

}

enum Roboto {
    static func thinItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-ThinItalic", size: size)!
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    static func mediumItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-MediumItalic", size: size)!
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }

}
