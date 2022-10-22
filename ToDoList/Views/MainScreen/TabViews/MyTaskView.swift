import SwiftUI

struct MyTaskView: View {
    @ObservedObject var viewModel = TaskViewModel()
    
    var body: some View {
        VStack {
            TaskHeader(action: {})
            
            SegmentedPickerExample(titles: ["Today", "Month"], selectedIndex: $viewModel.selectedIndex)
            
            
            if viewModel.selectedIndex == 1 {
                CustomCalendar(selectedDate: $viewModel.selectedDate)
            }
            
            TaskEditableList()
           
            Spacer()
        }
        .animation(.default, value: viewModel.selectedIndex)
    }
}

struct MyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskView()
    }
}
