import SwiftUI

struct CustomTabBarView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    @Binding var isPresented: Bool
    @State private var isCreatePressed = false
    
    var body: some View {
        NavigationView {
            GeometryReader { _ in
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
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .myTask, width: 74, height: 22, systemIconName: "checkmark.circle.fill", tabName: "My task")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .menu, width: 74, height: 24, systemIconName: "square.grid.2x2.fill", tabName: "Menu")
                            ZStack {
                                Button {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        isCreatePressed.toggle()
                                    }
                                } label: {
                                    Text("+")
                                        .font(.RobotoThinItalic)
                                        .frame(width: 60 , height: 60)
                                        .foregroundColor(.white)
                                        .background(RadialGradient(colors: [.firstColor, .secondColor], center: UnitPoint(x: 0, y: 0), startRadius: 90, endRadius: 20))
                                        .clipShape(Circle())
                                        .scaleEffect()
                                }
                            }
                            .offset(y: -34)
                            
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .quick, width: 74, height: 26, systemIconName: "list.bullet.rectangle.portrait.fill", tabName: "Quick")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: 74, height: 26, systemIconName: "person.fill", tabName: "Profile")
                        }
                        
                        .frame(height: 106)
                        .frame(maxWidth: .infinity)
                        .background(Color.customTabBarColor.shadow(radius: 2))
                    }
                    .offset(y: -10)
                }
                .offset(y: 10)
                .edgesIgnoringSafeArea(.bottom)
                .ignoresSafeArea(edges: .top)
                
                if isCreatePressed {
                    CreateView(isPresented: $isCreatePressed)
                        .cornerRadius(Constants.radiusFive)
                        .ignoresSafeArea()
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
    let systemIconName: String
    let tabName: LocalizedStringKey
    
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
