//
//  WalkthroughFirst.swift
//  ToDoList
//
//  Created by Артём on 18.07.22.
//

import SwiftUI

struct WalkthroughFirst: View {
    @State var isPresented: Bool
    
    var body: some View {
        VStack {
            Image("events")
                .padding(.top, 46)
            
            Text("Welcome to todo list")
                .font(.custom("Roboto-ThinItalic", size: 24))
                .foregroundColor(.customBlack)
                .padding(.top, 50)
            
            Text("Whats going to happen tomorrow?")
                .font(.custom("Roboto-Medium", size: 18))
                .font(.system(.title3))
                .foregroundColor(.customBlack)
                .padding(.top, 11)
            
            DotsView(firstColor: true,
                     secondColor: false,
                     thirdColor: false)
            
            ZStack {
                Image("pathFitst")
                    .resizable()
                
                Image("pathFirstBack")
                    .resizable()
                
                Button {
                    
                } label: {
                    Text("Get started")
                }
                .buttonStyle(CustomButtonStyleOnboarding())
            }
            .ignoresSafeArea()
            .frame(maxHeight: 362, alignment: .bottom)
            .padding(.top, 90)
                
            
        }
    }
}

struct WalkthroughFirst_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        WalkthroughFirst(isPresented: isPresented)
    }
}
