//
//  SavedJokesView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI

struct JokeDemo: Identifiable {
    var id: Int
    var name: String
}

struct SavedJokesView: View {
    
    @State var jokes: [JokeDemo] = [
           JokeDemo(id: 1, name: "vits 1"),
           JokeDemo(id: 2, name: "vits 2"),
           JokeDemo(id: 3, name: "vits 3"),
           JokeDemo(id: 4, name: "vits 4")
       ]
    
    var body: some View {
           NavigationView {
               List($jokes.indices, id: \.self) { index in
                   NavigationLink(destination: SavedJokesDetailView(joke: $jokes[index])) {
                       HStack {
                           Text(jokes[index].name)
                               .font(.title3)
                               .bold()
                               .lineLimit(1)
                               .truncationMode(.tail)
                       }
                       .tint(.gray)
                   }
               }
               .navigationTitle("Saved Jokes")
           }
       }
}

#Preview {
    SavedJokesView()
}
