import SwiftUI

struct QuickView: View {
    @StateObject private var viewModelNote = CreateNoteViewModel()
    @StateObject private var viewModelChecklist = CheckListViewModel()
    
    @State private var showNoteAlert = false
    @State private var showChecklistAlert = false
    @State private var selectedColor: Color = .red
    
    @State private var showNoteEdit = false
    @State private var isNoteCompleted = false
    
    @State private var showChecklistEdit = false
    @State private var showEditView = false
    
    var body: some View {
        ZStack {
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
                                    showNoteAlert.toggle()
                                }
                            } message: {
                                Text("What do you want to do?")
                            }
                            .alert(isPresented: $showNoteAlert) {
                                Alert(title: Text("You want to delete «\(viewModelNote.noteText)»?"),
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
                                          viewModelChecklist.checklistId = element.id
                                          viewModelChecklist.title = element.title
                                          showChecklistEdit.toggle()
                                      }
                                      .confirmationDialog("What do you want?", isPresented: $showChecklistEdit) {
                                          Button("Edit", role: .none) {
                                              showEditView.toggle()
                                          }
                                          Button("Delete Checklist", role: .destructive) {
                                              showChecklistAlert.toggle()
                                          } 
                                      } message: {
                                          Text("What do you want to do?")
                                      }
                                      .alert(isPresented: $showChecklistAlert) {
                                          Alert(title: Text("You want to delete «\(viewModelChecklist.title)» checklist?"),
                                                message: Text("You cannot undone this action."),
                                                primaryButton: .cancel(),
                                                secondaryButton: .destructive(Text("Delete")) {
                                              viewModelChecklist.deleteChecklist()
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
            if showEditView {
                EditChecklist(isPresented: $showChecklistEdit)
            }
        }
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView()
    }
}
