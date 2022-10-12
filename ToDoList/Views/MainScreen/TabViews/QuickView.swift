import SwiftUI

struct QuickView: View {
    @ObservedObject private var viewModel = QuickViewModel()

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
                    ForEach(viewModel.mergedResponseArray, id: \.1) { notes, checklists in
                        //MARK: Notes
                        NoteCell(color: notes.color, text: notes.description, isCompleted: notes.isCompleted)
                            .onLongPressGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    viewModel.selectedNote = notes.id
                                    viewModel.noteText = notes.description
                                    viewModel.selectedColor = notes.color
                                    isNoteCompleted = notes.isCompleted
                                    showNoteEdit.toggle()
                                }
                            }
                            .confirmationDialog("Delete this note?",
                                                isPresented: $showNoteEdit) {
                                Button(isNoteCompleted ? "Unmark" : "Mark as done") {
                                    if isNoteCompleted {
                                        isNoteCompleted.toggle()
                                        viewModel.isNoteCompleted = false
                                    } else {
                                        isNoteCompleted.toggle()
                                        viewModel.isNoteCompleted = true
                                    }
                                    viewModel.updateNote()
                                }
                                Button("Delete", role: .destructive) {
                                    showNoteAlert.toggle()
                                }
                            } message: {
                                Text("What do you want to do?")
                            }
                            .alert(isPresented: $showNoteAlert) {
                                Alert(title: Text("You want to delete «\(viewModel.noteText)»?"),
                                      message: Text("You cannot undone this action."),
                                      primaryButton: .cancel(),
                                      secondaryButton: .destructive(Text("Delete")) {
                                    viewModel.deleteNote()
                                })
                            }
                            .padding(.horizontal, 10)
                            .background(.white)
                            .cornerRadius(Constants.radiusThree)
                            .shadow(color: .secondary.opacity(0.3), radius: 2, x: 4, y: 2)
                        
                        //MARK: Checklists
                        ChecklistCell(content: checklists.items,
                                      title: checklists.title,
                                      color: checklists.color,
                                      itemContent: $viewModel.newItemContent,
                                      itemId: $viewModel.itemId,
                                      itemIsCompleted: $viewModel.isChecklistItemCompleted) {
                            viewModel.title = checklists.title
                            viewModel.color = checklists.color
                            viewModel.checklistId = checklists.id
                            viewModel.isChecklistItemCompleted.toggle()
                            viewModel.updateChecklist()
                        }
                                      .onLongPressGesture {
                                          showChecklistEdit.toggle()
                                      }
                                      .confirmationDialog("What do you want?", isPresented: $showChecklistEdit) {
                                          Button("Edit", role: .none) {
                                              withAnimation(.easeInOut(duration: 0.3)) {
                                                  viewModel.checklistId = checklists.id
                                                  viewModel.title = checklists.title
                                                  selectedChecklist = checklists.items
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
                                          Alert(title: Text("You want to delete «\(viewModel.title)» checklist?"),
                                                message: Text("You cannot undone this action."),
                                                primaryButton: .cancel(),
                                                secondaryButton: .destructive(Text("Delete")) {
                                              viewModel.deleteChecklist()
                                          })
                                      }
                                      .padding(.horizontal, 10)
                                      .background(.white)
                                      .cornerRadius(Constants.radiusThree)
                                      .shadow(color: .secondary.opacity(0.3), radius: 2, x: 4, y: 2)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.customWhiteBackground)
            
            if showEditView {
                EditChecklist(isPresented: $showEditView,
                              title: $viewModel.title,
                              color: $viewModel.color,
                              itemId: $viewModel.itemId,
                              selectedArray: $selectedChecklist,
                              updatedArray: $viewModel.checklistResponseItems,
                              updateAction: {
                    viewModel.editChecklist()
                },
                              deleteAction: {
                    viewModel.deleteCheclistItem()
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
