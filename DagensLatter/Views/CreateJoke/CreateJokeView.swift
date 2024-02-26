//
//  CreateJokeView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI
import CoreData

struct CreateJokeView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(
        entity: Joke.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.dateSaved, ascending: false)],
        predicate: NSPredicate(format: "userCreated == YES")
    ) var userCreatedJokes: FetchedResults<Joke>
    
    @State private var showingCreateJokeSheet = false
    @State private var editingJoke: Joke?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userCreatedJokes, id: \.self) { joke in
                    Text(JokeManager.fullJokeText(for: joke))
                        .onTapGesture {
                            editingJoke = joke
                            showingCreateJokeSheet = true
                        }
                }
                .onDelete(perform: { offsets in
                    JokeManager.deleteJokeInList(at: offsets, from: userCreatedJokes, in: moc)
                })
            }
            .navigationBarTitle("Your Jokes")
            .navigationBarItems(trailing: Button(action: {
                editingJoke = nil
                showingCreateJokeSheet = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingCreateJokeSheet) {
                UserCreatedJokesListView(jokeToEdit: $editingJoke)
                    .environment(\.managedObjectContext, self.moc)
            }
        }
    }
}
