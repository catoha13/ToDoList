import SwiftUI

struct QuickView: View {
    @StateObject private var viewModel = QuickViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Quick Notes")
                    .font(.RobotoThinItalicHeader)
                    .padding(.vertical, 50)
                    .alert(isPresented: $viewModel.isOffline) {
                        Alert(title: Text("Something went wrong"), message: Text(viewModel.alertMessage), dismissButton: Alert.Button.cancel(Text("Ok")))
                    }
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.mergedResponseArray, id: \.id) { notes, checklists, _ in
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
                            viewModel.updateNote.send()
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
                                withAnimation(.default) {
                                    viewModel.showNoteEditView.toggle()
                                }
                            }
                            Button("Delete", role: .destructive) {
                                viewModel.showNoteAlert.toggle()
                            }
                        } message: {
                            Text("What do you want to do?")
                        }
                        .alert(isPresented: $viewModel.showNoteAlert) {
                            Alert(title: Text("Delete") + Text(" «\(viewModel.noteText)»?"),
                                  message: Text("You cannot undo this action"),
                                  primaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteNote.send()
                            },
                                  secondaryButton: .cancel())
                        }
                        .padding(.horizontal, 10)
                        
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
                            viewModel.updateChecklist.send()
                        } longPressAction: {
                            viewModel.checklistId = checklists.id
                            viewModel.checklistTitle = checklists.title
                            viewModel.selectedChecklist = checklists.items
                            viewModel.isChecklistEditing.toggle()
                        }
                        .confirmationDialog("What do you want to do?", isPresented: $viewModel.isChecklistEditing) {
                            Button("Edit", role: .none) {
                                withAnimation(.default) {
                                    viewModel.showChecklistEditView.toggle()
                                }
                            }
                            Button("Delete", role: .destructive) {
                                viewModel.showChecklistAlert.toggle()
                            }
                        } message: {
                            Text("What do you want to do?")
                        }
                        .alert(isPresented: $viewModel.showChecklistAlert) {
                            Alert(title: Text("Delete") + Text(" «\(viewModel.checklistTitle)»?"),
                                  message: Text("You cannot undo this action"),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteChecklist.send()
                            })
                        }
                        .padding(.horizontal, 10)
                    }
                    .animation(.default, value: viewModel.mergedResponseArray.map { $0.0 })
                    .animation(.default, value: viewModel.mergedResponseArray.map { $0.1 })
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
                    viewModel.editChecklist.send()
                },
                              deleteAction: {
                    viewModel.deleteChecklistItem.send()
                })
            }
            
            if viewModel.showNoteEditView {
                EditNote(isPresented: $viewModel.showNoteEditView,
                         title: $viewModel.noteText,
                         color: $viewModel.selectedNoteColor,
                         updateAction: {
                    viewModel.updateNote.send()
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
