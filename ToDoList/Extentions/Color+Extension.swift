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
    
    
    //MARK: Gradient
    public static var firstColor: Color {
        return Color(UIColor(red: 249/255, green: 96/255, blue: 96/255, alpha: 1))
    }
    public static var secondColor: Color {
        return Color(UIColor(red: 246/255, green: 136/255, blue: 136/255, alpha: 1))
    }
}
