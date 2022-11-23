import SwiftUI

//MARK: Custom Coral Button
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

//MARK: Custom Coral Small Button
struct CustomCoralFilledButtonSmall: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }, label: {
            Text(text)
        })
        .buttonStyle(CustomSmallButtonStyle())
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

//MARK: Avatar upload button
struct CustomAvatarButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text("Upload\navatar\nsdfsddsafa\nsdfadsf")
                .foregroundColor(.clear)
        }
        .frame(width: 107, height: 104)
        .clipShape(Circle())
        .foregroundColor(.customGray)
        .overlay(Circle().stroke(lineWidth: 1).fill(Color.customCoral))
    }
}
struct DeleteCustomButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(uiImage: UIImage(named: "delete")!)
        }
    }
}

struct EditCustomButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(uiImage: UIImage(named: "edit")!)
        }
    }
}

struct AddProjectButton: View {
    var action: () -> ()
    var body: some View {
        Button {
            self.action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 80)
                Text("+")
                    .foregroundColor(.white)
                    .font(.RobotoThinItalic)
            }
            
            .frame(width: 70, height: 70)
        }
        .padding(.vertical, 30)
        .padding(.trailing, 250)
    }
}

struct ColorConfirmButton: View {
    var action: () -> ()
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text("Done")
        }
        .buttonStyle(CustomColorButtonStyle())
        .padding()
    }
}


struct CustomButtons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomCoralFilledButton(text: "Sign In", action: {})
            CustomBlueFilledButton(text: "Complete Task", action: {})
            CustomButton(text: "Sing Up", action: {})
            CustomCircleButton(action: {})
            CustomAvatarButton(action: {})
            DeleteCustomButton(action: {})
            EditCustomButton(action: {})
            AddProjectButton(action: {})
            ColorConfirmButton(action: {})
        }
        .previewLayout(.fixed(width: 400, height: 200))
    }
}

