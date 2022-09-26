import SwiftUI

struct QuickView: View {
    @StateObject private var viewModelNote = CreateNoteViewModel()
    @StateObject private var viewModelChecklist = CheckListViewModel()
    
    @State private var showAlert = false
    @State private var selectedColor: Color = .red
    
    @State private var showNoteEdit = false
    @State private var isNoteCompleted = false
    @State private var noteDescription = ""
    
    @State private var showChecklistEdit = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Notes")
                .font(.RobotoThinItalicHeader)
                .padding(.vertical, 50)
            ScrollView(showsIndicators: false) {
                //MARK: Notes
                ForEach(viewModelNote.notesArray, id: \.self) { item in
                    NoteCell(color: item.color, text: item.description, isCompleted: item.isCompleted)
                        .onLongPressGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModelNote.selectedNote = item.id
                                viewModelNote.noteText = item.description
                                viewModelNote.selectedColor = item.color
                                isNoteCompleted = item.isCompleted
                                noteDescription = item.description
                                showNoteEdit.toggle()
                            }
                        }
                        .confirmationDialog("Delete this note?",
                                            isPresented: $showNoteEdit) {
                            Button(isNoteCompleted ? "Unmark" : "Mark as done") {
                                if isNoteCompleted {
                                    isNoteCompleted.toggle()
                                    viewModelNote.isCompleted = false
                                } else {
                                    isNoteCompleted.toggle()
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
                
                //MARK: Checklists
                ForEach(viewModelChecklist.checklistResponseArray, id: \.self) { element  in
                    ChecklistCell(content: element.items,
                                  title: element.title,
                                  color: element.color,
                                  itemContent: $viewModelChecklist.newItemContent,
                                  itemId: $viewModelChecklist.itemId,
                                  itemIsCompleted: $viewModelChecklist.isCompleted) {
                        viewModelChecklist.title = element.title
                        viewModelChecklist.color = element.color
                        viewModelChecklist.checklistId = element.id
                        viewModelChecklist.isCompleted.toggle()
                        viewModelChecklist.updateChecklist()
                    }
                                  .onLongPressGesture {
                                      
                                      showChecklistEdit.toggle()
                                  }
                                  .confirmationDialog("What do you want?", isPresented: $showChecklistEdit) {
                                      Button("Delete", role: .destructive) {
                                          showAlert.toggle()
                                      }
                                  }
                                  .alert(isPresented: $showAlert) {
                                      Alert(title: Text("You want to delete «\(element.title)»?"),
                                            message: Text("You cannot undone this action."),
                                            primaryButton: .cancel(),
                                            secondaryButton: .destructive(Text("Delete")) {
                                          
                                      })
                                  }
                }
            }
            .padding(.horizontal, 10)
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
