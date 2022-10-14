import SwiftUI

struct QuickView: View {
    @ObservedObject private var viewModel = QuickViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Notes")
                    .font(.RobotoThinItalicHeader)
                    .padding(.vertical, 50)
                ScrollView(showsIndicators: false) {
                    //MARK: List
                    ForEach(viewModel.mergedResponseArray, id: \.id) { notes, checklists, id in
                        //MARK: Notes
                        NoteCell(color: notes.color, text: notes.description, isCompleted: notes.isCompleted) {
                            viewModel.selectedNote = notes.id
                            viewModel.noteText = notes.description
                            viewModel.selectedNoteColor = notes.color
                            viewModel.isNoteCompleted = notes.isCompleted
                            if viewModel.isNoteCompleted {
                                viewModel.isNoteCompleted.toggle()
                                viewModel.isNoteCompleted = false
                            } else {
                                viewModel.isNoteCompleted.toggle()
                                viewModel.isNoteCompleted = true
                            }
                            viewModel.updateNote()
                        } longTap: {
                            viewModel.selectedNote = notes.id
                            viewModel.noteText = notes.description
                            viewModel.selectedNoteColor = notes.color
                            viewModel.isNoteCompleted = notes.isCompleted
                            viewModel.isNoteEditing.toggle()
                        }
                        .confirmationDialog("Delete this note?",
                                            isPresented: $viewModel.isNoteEditing) {
                            Button("Edit") {
                                viewModel.showNoteEditView.toggle()
                            }
                            Button("Delete", role: .destructive) {
                                viewModel.showNoteAlert.toggle()
                            }
                        } message: {
                            Text("What do you want to do?")
                        }
                        .alert(isPresented: $viewModel.showNoteAlert) {
                            Alert(title: Text("You want to delete «\(viewModel.noteText)»?"),
                                  message: Text("You cannot undone this action."),
                                  primaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteNote()
                            },
                                  secondaryButton: .cancel())
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
                                      itemId: $viewModel.checklistItemId,
                                      itemIsCompleted: $viewModel.isChecklistItemCompleted) {
                            viewModel.checklistTitle = checklists.title
                            viewModel.checklistColor = checklists.color
                            viewModel.checklistId = checklists.id
                            viewModel.isChecklistItemCompleted.toggle()
                            viewModel.updateChecklist()
                        }
                                      .onLongPressGesture {
                                          viewModel.checklistId = checklists.id
                                          viewModel.checklistTitle = checklists.title
                                          viewModel.selectedChecklist = checklists.items
                                          viewModel.isChecklistEditing.toggle()
                                      }
                                      .confirmationDialog("What do you want?", isPresented: $viewModel.isChecklistEditing) {
                                          Button("Edit", role: .none) {
                                              viewModel.showChecklistEditView.toggle()
                                          }
                                          Button("Delete Checklist", role: .destructive) {
                                              viewModel.showChecklistAlert.toggle()
                                          }
                                      } message: {
                                          Text("What do you want to do?")
                                      }
                                      .alert(isPresented: $viewModel.showChecklistAlert) {
                                          Alert(title: Text("You want to delete «\(viewModel.checklistTitle)» checklist?"),
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
            
            if viewModel.showChecklistEditView {
                EditChecklist(isPresented: $viewModel.showChecklistEditView,
                              isEditable: $viewModel.isAddItemEnabled,
                              title: $viewModel.checklistTitle,
                              color: $viewModel.checklistColor,
                              itemId: $viewModel.checklistItemId,
                              selectedArray: $viewModel.selectedChecklist,
                              updatedArray: $viewModel.checklistResponseItems,
                              updateAction: {
                    viewModel.editChecklist()
                },
                              deleteAction: {
                    viewModel.deleteCheclistItem()
                })
            }
            
            if viewModel.showNoteEditView {
                EditNote(isPresented: $viewModel.showNoteEditView,
                         title: $viewModel.noteText,
                         color: $viewModel.selectedNoteColor,
                         updateAction: {
                    viewModel.updateNote()
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
