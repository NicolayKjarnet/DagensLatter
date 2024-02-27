//
//  SavedJokesView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI
import CoreData

struct SavedJokesView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(
        entity: Joke.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.dateSaved, ascending: false)]
    ) var savedJokes: FetchedResults<Joke>
    
    @State private var searchText: String = ""
    
    private var filteredJokes: [Joke] {
        if searchText.isEmpty {
            return Array(savedJokes)
        } else {
            return savedJokes.filter { joke in
                JokeManager.fullJokeText(for: joke).localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredJokes, id: \.self) { joke in
                    NavigationLink(destination: SavedJokesDetailView(joke: joke)) {
                        Text(JokeManager.fullJokeText(for: joke))
                            .font(.headline)
                            .lineLimit(1)
                            .modifier(TextModifier())
                    }
                }
                .onDelete(perform: { offsets in
                    JokeManager.deleteJokeInArray(at: offsets.map { filteredJokes[$0] }, context: moc)
                })
            }
            .emptyPlaceholder(when: filteredJokes, message: "No jokes found. Save a joke to see it here!", image: Image(systemName: "heart.slash"))
            .navigationTitle("Saved Jokes (\(filteredJokes.count))")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText)
            .onChange(of: searchText) {
            }
        }
    }
}
