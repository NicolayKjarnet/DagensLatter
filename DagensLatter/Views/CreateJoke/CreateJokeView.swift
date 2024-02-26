//
//  CreateJokeView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//
//
//import SwiftUI
//import CoreData
//
//struct CreateJokeView: View {
//    @Environment(\.managedObjectContext) private var moc
//
//    @FetchRequest(
//        entity: Joke.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.dateSaved, ascending: false)],
//        predicate: NSPredicate(format: "userCreated == YES")
//    ) var userCreatedJokes: FetchedResults<Joke>
//
//    @State private var showingCreateJokeSheet = false
//    @State private var editingJoke: Joke?
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(userCreatedJokes) { joke in
//                    Text(joke.joke ?? "No joke")
//                        .onTapGesture {
//                            editingJoke = joke
//                            showingCreateJokeSheet = true
//                        }
//                }
//                .onDelete(perform: deleteJoke)
//            }
//            .navigationBarTitle("Your Jokes")
//            .navigationBarItems(trailing: Button(action: {
//                editingJoke = nil
//                showingCreateJokeSheet = true
//            }) {
//                Image(systemName: "plus")
//            })
//            .sheet(isPresented: $showingCreateJokeSheet) {
//                UserCreatedJokesListView(jokeToEdit: $editingJoke)
//                    .environment(\.managedObjectContext, self.moc)
//            }
//        }
//    }
//
//    private func deleteJoke(at offsets: IndexSet) {
//        for index in offsets {
//            let joke = userCreatedJokes[index]
//            moc.delete(joke)
//        }
//        try? moc.save()
//    }
//}
//
//
////#Preview {
////    CreateJokeView()
////}
//
// MARK: - Funker med binding
import SwiftUI
import CoreData

struct CreateJokeView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(
        entity: Joke.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.dateSaved, ascending: false)],
        predicate: NSPredicate(format: "userCreated == YES")
    ) var userCreatedJokes: FetchedResults<Joke>
    
    @State private var showingJokeEditor = false
    @State private var editingJoke: Joke?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userCreatedJokes, id: \.self) { joke in
                    JokeCell(joke: joke)
                        .onTapGesture {
                            editingJoke = joke
                            showingJokeEditor = true
                        }
                }
                .onDelete(perform: { offsets in
                    JokeManager.deleteJokeInList(at: offsets, from: userCreatedJokes, in: moc)
                })
            }
            .navigationBarTitle("Your Jokes")
            .navigationBarItems(trailing: Button(action: {
                editingJoke = nil
                showingJokeEditor = true
            }) {
                Image(systemName: "plus")
            })
            //            .sheet(isPresented: $showingJokeEditor) {
            //                UserCreatedJokesListView(jokeToEdit: $editingJoke)
            //                    .environment(\.managedObjectContext, self.moc)
            //            }
            .sheet(isPresented: $showingJokeEditor){
                if let jokeToEdit = editingJoke {
                    UserCreatedJokesListView(jokeToEdit: $editingJoke)
                        .environment(\.managedObjectContext, self.moc)
                } else {
                    // Handle the creation of a new joke
                    let newJoke = Joke(context: moc)
                }
            }
        }
        
    }
    struct JokeCell: View {
        let joke: Joke
        
        var body: some View {
            HStack {
                Text(JokeManager.fullJokeText(for: joke))
                Spacer()
                Text(joke.category ?? "Unknown")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
    }
}
    

#Preview {
    CreateJokeView()
}


//// MARK: -
//    import SwiftUI
//    import CoreData
//
//struct CreateJokeView: View {
//    @Environment(\.managedObjectContext) private var moc
//
//    @FetchRequest(
//        entity: Joke.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.dateSaved, ascending: false)],
//        predicate: NSPredicate(format: "userCreated == YES")
//    ) var userCreatedJokes: FetchedResults<Joke>
//
//    @State private var showingJokeEditor = false
//    @State private var editingJoke: Joke?
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(userCreatedJokes, id: \.self) { joke in
//                    JokeCell(joke: joke)
//                        .onTapGesture {
//                            editingJoke = joke
//                            showingJokeEditor = true
//                        }
//                }
//                .onDelete(perform: deleteJoke)
//            }
//            .navigationBarTitle("Your Jokes")
//            .navigationBarItems(trailing: Button(action: {
//                editingJoke = nil
//                showingJokeEditor = true
//            }) {
//                Image(systemName: "plus")
//            })
//            //            .sheet(isPresented: $showingJokeEditor) {
//            //                UserCreatedJokesListView(jokeToEdit: $editingJoke)
//            //                    .environment(\.managedObjectContext, self.moc)
//            //            }
//            .sheet(isPresented: $showingJokeEditor){
//                if let jokeToEdit = editingJoke {
//                    UserCreatedJokesListView(joke: jokeToEdit)
//                        .environment(\.managedObjectContext, self.moc)
//                } else {
//                    // Handle the creation of a new joke
//                    let newJoke = Joke(context: moc)
//                }
//            }
//        }
//
//        private func deleteJoke(at offsets: IndexSet) {
//            for index in offsets {
//                let joke = userCreatedJokes[index]
//                moc.delete(joke)
//            }
//            try? moc.save()
//        }
//
//        private struct JokeCell: View {
//            let joke: Joke
//
//            var body: some View {
//                HStack {
//                    Text(JokeManager.fullJokeText(for: joke))
//                    Spacer()
//                    Text(joke.category ?? "Unknown")
//                        .foregroundColor(.secondary)
//                        .font(.subheadline)
//                }
//            }
//        }
//    }
//}

//#Preview {
//    CreateJokeView()
//}
