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
        ScrollView {
            VStack(spacing: 16) {
                Text("Rate Joke")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Category:")
                            .fontWeight(.semibold)
                        Text(joke.category ?? "Unknown")
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    
                    if let dateSaved = joke.dateSaved {
                        Text("Saved on \(dateSaved, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                .shadow(radius: 1)
                
                Text(JokeManager.fullJokeText(for: joke))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .shadow(radius: 1)
                    .font(.title3)
                
                StarRatingStyle(rating: $rating)
                    .padding()
                
                TextField("Notes on joke...", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Save Rating") {
                    saveRating()
                }
                .buttonStyle(FilledButtonStyle(backgroundColor: Color("AccentOrange" )))
                .fontWeight(.bold)
                
                Button("Delete Joke") {
                    showingDeleteAlert = true
                }
                .buttonStyle(FilledButtonStyle(backgroundColor: Color("WarningRed")))
                .fontWeight(.bold)
                
                
                Spacer()
            }
            .padding([.horizontal, .bottom])
        }
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
        .navigationBarTitleDisplayMode(.automatic)
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
