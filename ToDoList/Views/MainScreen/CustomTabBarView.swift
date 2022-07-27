import SwiftUI

struct CustomTabBarView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    @Binding var isPresented: Bool
    @State private var isCreatePressed = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .myTask:
                    MyTaskView()
                case .menu:
                    MenuView()
                case .quick:
                    QuickView()
                case .profile:
                    ProfileView()
                }
                Spacer()
                
                ZStack {
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .myTask, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "checkmark.circle.fill", tabName: "My task")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .menu, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "square.grid.2x2.fill", tabName: "Menu")
                        ZStack {
                            Button {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    isCreatePressed.toggle()
                                }
                            } label: {
                                Text("+")
                                    .font(.RobotoThinItalic)
                                    .frame(width: geometry.size.width/6 , height: geometry.size.width/6)
                                    .foregroundColor(.white)
                                    .background(RadialGradient(colors: [.firstColor, .secondColor], center: UnitPoint(x: 0, y: 0), startRadius: 90, endRadius: 20))
                                    .clipShape(Circle())
                                    .scaleEffect()
                            }
                        }
                        .offset(y: -geometry.size.height/8/3)
                        
                        
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .quick, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "list.bullet.rectangle.portrait.fill", tabName: "Quick")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.fill", tabName: "Profile")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height/8)
                    .background(Color.customTabBarColor.shadow(radius: 2))
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .ignoresSafeArea(edges: .top)
            .overlay {
                if isCreatePressed {
                    CreateView(isPresented: $isCreatePressed)
                        .cornerRadius(Constants.radiusFive)
                        .ignoresSafeArea()
                }
            }
            .onTapGesture {
                if isCreatePressed == true {
                    isCreatePressed.toggle()
                }
            }
        }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        CustomTabBarView(viewRouter: ViewRouter(), isPresented: $isPresented)
            .preferredColorScheme(.light)
    }
}


struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 20)
            Text(tabName)
                .font(.custom("Roboto-ThinItalic", size: 12))
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? .white : .gray)
    }
}
