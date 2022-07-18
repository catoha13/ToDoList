//
//  WalkthroughSecond.swift
//  ToDoList
//
//  Created by Артём on 18.07.22.
//

import SwiftUI

struct WalkthroughSecond: View {
    @State var isPresented: Bool
    
    var body: some View {
            VStack {
                Image("events")
                    .padding(.top, 46)
                
                Text("Work happens")
                    .font(.custom("Roboto-ThinItalic", size: 24))
                    .foregroundColor(.customBlack)
                    .padding(.top, 50)
                
                Text("Get notified when work happens.")
                    .font(.custom("Roboto-Medium", size: 18))
                    .font(.system(.title3))
                    .foregroundColor(.customBlack)
                    .padding(.top, 11)
                
                DotsView(firstColor: false,
                         secondColor: true,
                         thirdColor: false)
                
                ZStack {
                    Image("pathSecond")
                        .resizable()
                    
                    Image("pathSecondBack")
                        .resizable()
                    
                    NavigationLink {
                        WalkthroughThird(isPresented: isPresented)
                    } label: {
                        Text("Get Started")
                    }
                    .buttonStyle(CustomButtonStyleOnboarding())
                }
                .ignoresSafeArea()
                .frame(maxHeight: 362, alignment: .bottom)
                .padding(.top, 90)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

struct WalkthroughSecond_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        WalkthroughSecond(isPresented: isPresented)
    }
}
