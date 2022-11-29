import SwiftUI

struct CustomButtonStyleOnboarding: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(width: 293, height: 48)
            .background(.white)
            .font(.custom("Roboto-ThinItalic", size: 18))
            .foregroundColor(.customBlack)
            .cornerRadius(Constants.radiusFive)
            .shadow(color: .customShadow, radius: 4, x: 4, y: 4)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(width: 327, height: 48)
            .background(Color.customCoral)
            .font(.custom("Roboto-ThinItalic", size: 18))
            .foregroundColor(.white)
            .cornerRadius(Constants.radiusFive)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CustomSmallButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(width: 150, height: 48)
            .background(Color.customCoral)
            .font(.custom("Roboto-ThinItalic", size: 18))
            .foregroundColor(.white)
            .cornerRadius(Constants.radiusFive)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CustomBlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(width: 327, height: 48)
            .background(Color.customBlue)
            .font(.custom("Roboto-ThinItalic", size: 18))
            .foregroundColor(.white)
            .cornerRadius(Constants.radiusFive)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CustomColorButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(width: 295, height: 48)
            .background(Color.customCoral)
            .font(.custom("Roboto-ThinItalic", size: 18))
            .foregroundColor(.white)
            .cornerRadius(Constants.radiusFive)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

