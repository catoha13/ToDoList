//
//  LogoView.swift
//  ToDoList
//
//  Created by Артём on 18.07.22.
//

import SwiftUI

struct LogoView: View {
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Image("logo")
                .frame(width: 149, height: 149)
            
            Text("todo list")
                .font(.Roboto)
                .foregroundColor(.customBlack)
            
        }
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                isPresented.toggle()
            }
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            WalkthroughFirst(isPresented: isPresented)
            
        })
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
