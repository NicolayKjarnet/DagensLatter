//
//  SavedJokesDetailView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI

struct SavedJokesDetailView: View {
    @Binding var joke: JokeDemo
        
        var body: some View {
            Text(joke.name)
                .navigationTitle(joke.name)
        }
}

#Preview {
    SavedJokesDetailView(joke: .constant(JokeDemo(id: 1, name: "Preview vits")))
}
