//
//  DotsView.swift
//  ToDoList
//
//  Created by Артём on 18.07.22.
//

import SwiftUI

struct DotsView: View {
    @State var firstColor: Bool
    @State var secondColor: Bool
    @State var thirdColor: Bool
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(firstColor ? Color.black : Color.customDot)
            
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(secondColor ? Color.black : Color.customDot)
            
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(thirdColor ? Color.black : Color.customDot)
        }
        .padding()
    }
}

struct DotsView_Previews: PreviewProvider {
    
    static var previews: some View {
        DotsView(firstColor: true, secondColor: false, thirdColor: false)
            .previewLayout(.fixed(width: 100, height: 20))
    }
}
