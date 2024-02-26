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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.savedJokes, id: \.self) { joke in
                    NavigationLink(destination: SavedJokesDetailView(joke: joke)) {
                        Text(JokeManager.fullJokeText(for: joke))
                            .font(.headline)
                            .lineLimit(1)
                    }
                }
                .onDelete(perform: { offsets in
                    JokeManager.deleteJokeInList(at: offsets, from: savedJokes, in: moc)
                })
            }
            .emptyPlaceholder(when: savedJokes, message: "No saved jokes. Save a joke to see it here!", image: Image(systemName: "heart.slash"))
            .navigationTitle("Saved Jokes (\(savedJokes.count))")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
