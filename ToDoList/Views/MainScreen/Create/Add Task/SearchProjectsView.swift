import SwiftUI

struct SearchProjectsView: View {
    @Binding var projects: [ProjectResponceData]
    @Binding var projectName: String
    @Binding var projectId: String
    @State var action: () -> ()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(projects, id: \.id) { project in
                HStack {
                    Button {
                        projectName = project.title ?? ""
                        projectId = project.id ?? ""
                        action()
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .frame(width: 26, height: 26)
                                    .foregroundColor(Color(hex: project.color ?? ""))
                                    .opacity(0.3)
                                Circle()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(Color(hex: project.color ?? ""))
                            }
                            
                            Text(project.title ?? "")
                                .font(.RobotoThinItalicSmall)
                                .foregroundColor(.black)
                        }
                        .frame(height: 40)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .background(Color.customBar)
        .padding(.top, 20)
        .frame(width: 343, height: 590)
    }
}

struct SearchProjectsView_Previews: PreviewProvider {
    @State static var projects: [ProjectResponceData] = []
    @State static var projectName = ""
    @State static var projectId = ""
    static var previews: some View {
        SearchProjectsView(projects: $projects,
                           projectName: $projectName,
                           projectId: $projectId,
                           action: {})
    }
}
