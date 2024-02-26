//
//  SavedJokesDetailView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI

struct SavedJokesDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var joke: Joke
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var showingDeleteAlert = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack {
            
            HStack{
                Text("Category:")
                Text(joke.category ?? "Unknown")
            }
            .font(.title3)
            
            if let dateSaved = joke.dateSaved {
                Text("Saved on \(dateSaved, formatter: dateFormatter)")
                    .font(.subheadline)
                    .tint(Color.secondary)
                    .padding(.bottom)
            }
            
            Text(JokeManager.fullJokeText(for: joke))
                .padding()
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 10.0)))
                .foregroundColor(.primary)
            
            StarRatingView(rating: $rating)
                .padding()
            
            TextField("Notes on joke...", text: $comment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save Rating") {
                saveRating()
            }
            .buttonStyle(FilledButtonStyle())
            .padding()
            
            Button("Delete Joke") {
                showingDeleteAlert = true
            }
            .buttonStyle(FilledButtonStyle())
            .foregroundColor(.red)
            .padding()
        } // MARK: - VSTACK
        .padding()
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Joke"),
                message: Text("Are you sure you want to delete this joke?"),
                primaryButton: .destructive(Text("Delete")) {
                    JokeManager.deleteJoke(joke: joke, context: moc)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarTitle("Rate Joke", displayMode: .automatic)
        .onAppear {
            refreshView()
        }
    }
    
    private func saveRating() {
        joke.rating = Int16(rating)
        joke.comments = comment
        do {
            try moc.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Could not save managed object context: \(error)")
        }
    }
    
    private func refreshView() {
        joke.managedObjectContext?.refresh(joke, mergeChanges: true)
        rating = Int(joke.rating)
        comment = joke.comments ?? ""
    }
}
