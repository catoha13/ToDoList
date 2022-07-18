//
//  ButtonView.swift
//  ToDoList
//
//  Created by Артём on 18.07.22.
//

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

