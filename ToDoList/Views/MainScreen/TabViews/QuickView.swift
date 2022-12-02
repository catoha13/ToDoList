import SwiftUI

struct QuickView: View {
    @StateObject private var viewModel = QuickViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                TopHeader(text: "Quick Notes")
                    .alert(isPresented: $viewModel.isOffline) {
                        Alert(title: Text("Something went wrong"), message: Text(viewModel.alertMessage), dismissButton: Alert.Button.cancel(Text("Ok")))
                    }
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.mergedResponseArray, id: \.id) { item in
                        switch item {
                            
                            //MARK: Notes
                        case .notes(let note):
                            NoteCell(color: note.color ?? "",
                                     text: note.description ?? "",
                                     isCompleted: note.isCompleted ?? false,
                                     isOffline: viewModel.isOffline) {
                                viewModel.selectedNote = note.id ?? ""
                                viewModel.noteText = note.description ?? ""
                                viewModel.selectedNoteColor = note.color ?? ""
                                viewModel.isNoteCompleted = note.isCompleted ?? false
                                if viewModel.isNoteCompleted {
                                    viewModel.isNoteCompleted.toggle()
                                    viewModel.isNoteCompleted = false
                                } else {
                                    viewModel.isNoteCompleted.toggle()
                                    viewModel.isNoteCompleted = true
                                }
                                viewModel.updateNote.send()
                            } longTap: {
                                viewModel.selectedNote = note.id ?? ""
                                viewModel.noteText = note.description ?? ""
                                viewModel.selectedNoteColor = note.color ?? ""
                                viewModel.isNoteCompleted = note.isCompleted ?? false
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
                        case .checklists(let checklist):
                            ChecklistCell(content: checklist.items,
                                          title: checklist.title,
                                          color: checklist.color,
                                          isOffline: viewModel.isOffline,
                                          itemContent: $viewModel.newItemContent,
                                          itemId: $viewModel.checklistItemId,
                                          itemIsCompleted: $viewModel.isChecklistItemCompleted) {
                                viewModel.checklistTitle = checklist.title
                                viewModel.checklistColor = checklist.color
                                viewModel.checklistId = checklist.id
                                viewModel.isChecklistItemCompleted.toggle()
                                viewModel.updateChecklist.send()
                            } longPressAction: {
                                viewModel.checklistId = checklist.id
                                viewModel.checklistTitle = checklist.title
                                viewModel.selectedChecklist = checklist.items
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
                    }
                    .animation(.default, value: viewModel.mergedResponseArray)
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
