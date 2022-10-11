import SwiftUI

struct QuickView: View {
    @StateObject private var viewModelNote = NoteViewModel()
    @StateObject private var viewModelChecklist = CheckListViewModel()
    
    @State private var showNoteAlert = false
    @State private var showChecklistAlert = false
    @State private var selectedColor: Color = .red
    
    @State private var showNoteEdit = false
    @State private var isNoteCompleted = false
    
    @State private var showChecklistEdit = false
    @State private var showEditView = false
    @State private var selectedChecklist = [ChecklistItemsModel]()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Notes")
                    .font(.RobotoThinItalicHeader)
                    .padding(.vertical, 50)
                ScrollView(showsIndicators: false) {
                    //MARK: List
                    ForEach(Array(zip(viewModelNote.notesArray, viewModelChecklist.checklistResponseArray)), id: \.0) { notes, checklists in
                        //MARK: Notes
                        NoteCell(color: notes.color, text: notes.description, isCompleted: notes.isCompleted)
                            .onLongPressGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    viewModelNote.selectedNote = notes.id
                                    viewModelNote.noteText = notes.description
                                    viewModelNote.selectedColor = notes.color
                                    isNoteCompleted = notes.isCompleted
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
                        
                        //MARK: Checklists
                        ChecklistCell(content: checklists.items,
                                      title: checklists.title,
                                      color: checklists.color,
                                      itemContent: $viewModelChecklist.newItemContent,
                                      itemId: $viewModelChecklist.itemId,
                                      itemIsCompleted: $viewModelChecklist.isCompleted) {
                            viewModelChecklist.title = checklists.title
                            viewModelChecklist.color = checklists.color
                            viewModelChecklist.checklistId = checklists.id
                            viewModelChecklist.isCompleted.toggle()
                            viewModelChecklist.updateChecklist()
                        }
                                      .onLongPressGesture {
                                          viewModelChecklist.checklistId = checklists.id
                                          viewModelChecklist.title = checklists.title
                                          selectedChecklist = checklists.items
                                          showChecklistEdit.toggle()
                                      }
                                      .confirmationDialog("What do you want?", isPresented: $showChecklistEdit) {
                                          Button("Edit", role: .none) {
                                              withAnimation(.easeInOut(duration: 0.3)) {
                                                  showEditView.toggle()
                                              }
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
                    .frame(width: 343)
                    .background(.white)
                    .cornerRadius(Constants.radiusThree)
                    .shadow(color: .secondary.opacity(0.3), radius: 2, x: 4, y: 2)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.customWhiteBackground)
            .onAppear {
                viewModelNote.fetchAllNotes()
                viewModelChecklist.fetchAllChecklists()
            }
            if showEditView {
                EditChecklist(isPresented: $showEditView,
                              title: $viewModelChecklist.title,
                              color: $viewModelChecklist.color,
                              itemId: $viewModelChecklist.itemId,
                              selectedArray: $selectedChecklist,
                              updatedArray: $viewModelChecklist.checklistResponseItems,
                              updateAction: {
                    viewModelChecklist.editChecklist()
                },
                              deleteAction: {
                    viewModelChecklist.deleteCheclistItem()
                })
            }
        }
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView()
    }
}
