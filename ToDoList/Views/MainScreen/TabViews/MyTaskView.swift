import SwiftUI

struct MyTaskView: View {
    @ObservedObject var viewModel = TaskViewModel()
    
    var body: some View {
        VStack {
            TaskHeader(action: {})
            
            SegmentedPickerExample(titles: ["Today", "Month"], selectedIndex: $viewModel.selected)
            
            TaskEditableList()
           
            Spacer()
        }
    }
}

struct MyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskView()
    }
}
