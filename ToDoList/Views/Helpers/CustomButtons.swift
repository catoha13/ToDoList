import SwiftUI

struct CustomButtons: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//MARK: Custom Filled Button
struct CustomCoralFilledButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }, label: {
            Text(text)
        })
        .buttonStyle(CustomButtonStyle())
    }
}

//MARK: Custom Blue Button
struct CustomBlueFilledButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }, label: {
            Text(text)
        })
        .buttonStyle(CustomBlueButtonStyle())
    }
}

//MARK: Custom Button
struct CustomButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }, label: {
            Text(text)
        })
        .font(.RobotoMediumItalic)
        .foregroundColor(.customCoral)
    }
}

struct CustomCircleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text("+")
                .frame(width: 60, height: 60)
//                .background(Color.customCoral) // change to gradient
                .background(RadialGradient(colors: [.firstColor, .secondColor], center: UnitPoint(x: 0, y: 0), startRadius: 90, endRadius: 20))
                .foregroundColor(.white)
                .font(.RobotoThinItalic)
                .clipShape(Circle())
        }
    }
}

struct CustomCreateButton: View {
    var action: () -> Void
    var text: String
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text(text)
                .font(Font(Roboto.thinItalic(size: 18)))
                .foregroundColor(.customBlack)
        }
    }
}


struct CustomButtons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomButtons()
            CustomCoralFilledButton(text: "Sign In", action: {})
            CustomBlueFilledButton(text: "Complete Task", action: {})
            CustomButton(text: "Sing Up", action: {})
            CustomCircleButton(action: {})
        }
        .previewLayout(.fixed(width: 400, height: 200))
    }
}

