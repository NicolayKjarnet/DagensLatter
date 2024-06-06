//
//  CreateOrEditJokeListView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI
import CoreData

struct CreateOrEditJokeListView: View {
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
                if userCreatedJokes.isEmpty {
                    VStack {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text("No jokes found. Create a new joke!")
                            .modifier(TextModifier())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(userCreatedJokes, id: \.self) { joke in
                        HStack {
                            Text(JokeManager.fullJokeText(for: joke))
                                .onTapGesture {
                                    editingJoke = joke
                                    showingCreateJokeSheet = true
                                }
                            
                            Spacer()
                            
                            if let category = joke.category {
                                Text(category)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: { offsets in
                        JokeManager.deleteJokeInList(at: offsets, from: userCreatedJokes, in: moc)
                    })
                }
            }
            .navigationTitle("Your Jokes")
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
