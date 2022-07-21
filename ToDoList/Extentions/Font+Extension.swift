import Foundation
import SwiftUI

extension Font {
    static var RobotoThinItalic: Font {
            Font.custom("Roboto-ThinItalic", size: 24, relativeTo: .title2)
        }
    static var RobotoThinItalicLarge: Font {
            Font.custom("Roboto-ThinItalic", size: 48, relativeTo: .title)
        }

    static var RobotoMedium: Font {
            Font.custom("Roboto-Medium", size: 18, relativeTo: .title3)
        }

}
