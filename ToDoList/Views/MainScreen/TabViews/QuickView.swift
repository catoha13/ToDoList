import SwiftUI

struct QuickView: View {
    @StateObject private var viewModelNote = CreateNoteViewModel()
    @StateObject private var viewModelChecklist = CheckListViewModel()
    @State private var showAlert = false
    @State private var showEdit = false
    @State private var selectedColor: Color = .red
    @State private var isCompleted = false
    @State private var noteDescription = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Notes")
                .font(.RobotoThinItalicHeader)
                .padding(.vertical, 50)
            
            ScrollView(showsIndicators: false) {
                ForEach(viewModelNote.notesArray, id: \.self) { item in
                    NoteCell(color: item.color, text: item.description, isCompleted: item.isCompleted)
                        .onLongPressGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModelNote.selectedNote = item.id
                                viewModelNote.noteText = item.description
                                viewModelNote.selectedColor = item.color
                                isCompleted = item.isCompleted
                                noteDescription = item.description
                                showEdit.toggle()
                            }
                        }
                        .confirmationDialog("Delete this note?",
                                            isPresented: $showEdit) {
                            Button(isCompleted ? "Unmark" : "Mark as done") {
                                if isCompleted {
                                    isCompleted.toggle()
                                    viewModelNote.isCompleted = false
                                } else {
                                    isCompleted.toggle()
                                    viewModelNote.isCompleted = true
                                }
                                viewModelNote.updateNote()
                            }
                            Button("Delete", role: .destructive) {
                                showAlert.toggle()
                            }
                        } message: {
                            Text("What do you want to do?")
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("You want to delete «\(noteDescription)»?"),
                                  message: Text("You cannot undone this action."),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Delete")) {
                                viewModelNote.deleteNote()
                            })
                        }
                }
                .background(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.customWhiteBackground)
        .onAppear {
            viewModelNote.fetchAllNotes()
            viewModelChecklist.fetchAllChecklists()
        }
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView()
    }
}
