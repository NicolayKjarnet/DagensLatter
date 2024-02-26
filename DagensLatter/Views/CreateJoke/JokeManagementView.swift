////
////  JokeManagementView.swift
////  DagensLatter
////
////  Created by Nicolay Kjærnet on 26/02/2024.
////
//
//import SwiftUI
//import CoreData
//
//struct JokeManagementView: View {
//    @Environment(\.managedObjectContext) private var moc
//    @FetchRequest(
//        entity: Joke.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.dateSaved, ascending: false)],
//        predicate: NSPredicate(format: "userCreated == YES")
//    ) var userCreatedJokes: FetchedResults<Joke>
//    
//    @State private var showingCreationSheet = false
//    @State private var showingEditSheet = false
//    @State private var editingJoke: Joke?
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(userCreatedJokes) { joke in
//                    JokeCellView(joke: joke)
//                        .onTapGesture {
//                            self.editingJoke = joke
//                            self.showingEditSheet = true
//                        }
//                }
//                .onDelete(perform: { offsets in
//                    JokeManager.deleteJokeInList(at: offsets, from: userCreatedJokes, in: moc)
//                })
//            }
//            .navigationBarTitle("Your Jokes")
//            .navigationBarItems(trailing: Button(action: {
//                self.showingCreationSheet = true
//            }) {
//                Image(systemName: "plus")
//            })
//            .sheet(isPresented: $showingCreationSheet) {
//                // Provide a new Joke instance to the editor view for creation
//                JokeEditorView(jokeToEdit: .constant(Joke(context: moc)))
//                    .environment(\.managedObjectContext, self.moc)
//            }
//            .sheet(isPresented: $showingEditSheet) {
//                // Pass the selected joke to the editor view for editing
//                if let jokeToEdit = editingJoke {
//                    JokeEditorView(jokeToEdit: .constant(jokeToEdit))
//                        .environment(\.managedObjectContext, self.moc)
//                }
//            }
//        }
//    }
//}
