import SwiftUI

struct QuickView: View {
    @StateObject private var viewModelNote = CreateNoteViewModel()
    @State private var showAlert = false
    @State private var showEdit = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Notes")
                .font(.RobotoThinItalicHeader)
                .padding(.vertical, 50)
            
            ScrollView {
                ForEach(viewModelNote.notesArray, id: \.self) { item in
                    NoteCell(color: item.color, text: item.description, isCompleted: item.isCompleted)
                        .shadow(color: .customShadow, radius: 9, x: 5, y: 5)
                        .onLongPressGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModelNote.selectedNote = item.id
                                viewModelNote.noteText = item.description
                                viewModelNote.selectedColor = item.color
                                if item.isCompleted {
                                    viewModelNote.isCompleted = false
                                } else {
                                    viewModelNote.isCompleted = true
                                }
                                showEdit.toggle()
                            }
                        }
                        .confirmationDialog("Delete this note?",
                                            isPresented: $showEdit) {
                            Button(item.isCompleted ? "Unmark" : "Mark as done") {
                                viewModelNote.updateNote()
                            }
                            Button("Delete", role: .destructive) {
                                showAlert.toggle()
                            }
                        } message: {
                            Text("You can't undo this action")
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("You cannot undone this action."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete")) {
                                viewModelNote.deleteNote()
                            })
                        }
                }
                .background(.white)
                .shadow(color: .customShadow, radius: 9, x: 5, y: 5)
            }
        }
        .background(Color.customWhiteBackground)
        .onAppear {
            viewModelNote.fetchAllNotes()
        }
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView()
    }
}
