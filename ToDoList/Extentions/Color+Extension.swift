import Foundation
import SwiftUI

extension Color {
    //MARK: Custom Colors
    public static var customGray: Color {
        return Color(UIColor(red: 0.776, green: 0.776, blue: 0.776, alpha: 1))
    }
    public static var customCoral: Color {
        return Color(UIColor(red: 0.976, green: 0.376, blue: 0.376, alpha: 1))
    }
    public static var customBlack: Color {
        return Color(UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1))
    }
    public static var customPurple: Color {
        return Color(UIColor(red: 0.522, green: 0.375, blue: 0.976, alpha: 1))
    }
    public static var customShadow: Color {
        return Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25))
    }
    public static var customTabBarColor: Color {
        return Color(UIColor(red: 0.162, green: 0.181, blue: 0.307, alpha: 1))
    }
    public static var customBlue: Color {
        return Color(hex: "#6074F9")
    }
    public static var customPink: Color {
        return Color(hex: "#E42B6A")
    }
    public static var customGreen: Color {
        return Color(hex: "#5ABB56")
    }
    public static var customDarkPurple: Color {
        return Color(hex: "#3D3A62")
    }
    public static var customBiege: Color {
        return Color(hex: "#F4CA8F")
    }
    public static var customBar: Color {
        return Color(UIColor(red: 0.956, green: 0.956, blue: 0.956, alpha: 1))
    }
    public static var customWhiteBackground: Color {
        return Color(UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1))
    }
    
    //MARK: Gradient
    public static var firstColor: Color {
        return Color(UIColor(red: 249/255, green: 96/255, blue: 96/255, alpha: 1))
    }
    public static var secondColor: Color {
        return Color(UIColor(red: 246/255, green: 136/255, blue: 136/255, alpha: 1))
    }
}

//MARK: Add hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
