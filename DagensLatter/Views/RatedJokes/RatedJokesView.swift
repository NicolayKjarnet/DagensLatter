//
//  RatedJokesView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI
import CoreData

struct RatedJokesView: View {
    @Environment(\.managedObjectContext) private var moc
    @State private var selectedCategory: String = "All"
    @State private var selectedRating: Int16? = nil
    
    // FetchRequest to automatically update the view when the data changes.
    @FetchRequest(
        entity: Joke.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.rating, ascending: false)],
        predicate: nil // We will update this predicate when filters change
    ) var jokes: FetchedResults<Joke>
    
    private let categories = ["All", "Dark", "Programming", "Misc", "Pun", "Spooky", "Christmas"]
    private let ratings = Array(1...5).reversed()
    
    var body: some View {
        NavigationView {
            List {
                
                Picker("Filter by Category", selection: $selectedCategory.onChange(updatePredicate)) {
                    ForEach(self.categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("Filter by rating", selection: $selectedRating.onChange(updatePredicate)) {
                    Text("All").tag(Int16?.none)
                    ForEach(ratings, id: \.self) { rating in
                        Text("\(rating) Stars").tag(Int16?(Int16(rating)))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                ForEach(jokes) { joke in
                    if joke.category == selectedCategory || selectedCategory == "All" {
                        JokeRow(joke: joke)
                    }
                }
            }
            .navigationTitle("Rated Jokes")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func updatePredicate() {
        var predicates: [NSPredicate] = []
        
        if selectedCategory != "All" {
            predicates.append(NSPredicate(format: "category == %@", selectedCategory))
        }
        
        if let rating = selectedRating {
            predicates.append(NSPredicate(format: "rating == %d", rating))
        } else {
            
        }
        
        let compoundPredicate = predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        jokes.nsPredicate = compoundPredicate
    }
}

struct JokeRow: View {
    @ObservedObject var joke: Joke
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let joke = joke.joke{
                Text(joke)
                    .font(.headline)
            } else if let setup = joke.setup, let delivery = joke.delivery {
                Text(setup).font(.headline)
                Text(delivery).font(.subheadline)
            }
            Text("Rating: \(joke.rating)/5").font(.subheadline)
            if let comments = joke.comments, !comments.isEmpty {
                Text("Notes: \(comments)").font(.caption).foregroundColor(.secondary)
            }
            
        }
        .padding(.vertical, 4)
    }
}

// Use this View Extension to respond to onChange events
extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}


#Preview {
    RatedJokesView()
}
