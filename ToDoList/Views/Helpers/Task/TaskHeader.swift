import SwiftUI

struct TaskHeader: View {
    @State var action: () -> ()
    var body: some View {
        HStack {
            Spacer()
            Text("Work List")
                .font(Font(Roboto.thinItalic(size: 20)))
                .foregroundColor(.white)
                .padding(.trailing, -40)
                .padding(.top, 50)
                .padding(.bottom)
            Spacer()
            Button {
                action()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 24, height: 21)
                    .padding(.trailing, 24)
                    .padding(.top, 50)
                    .padding(.bottom)
                    .shadow(radius: 4)
                    .foregroundColor(.white)
            }
        }
        .background(Color.customCoral)
    }
}

struct TaskHeader_Previews: PreviewProvider {
    static var previews: some View {
        TaskHeader(action: {})
    }
}
