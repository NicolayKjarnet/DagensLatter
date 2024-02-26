//
//  JokeCellView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 26/02/2024.
//

import SwiftUI

struct JokeCellView: View {
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

//#Preview {
//    JokeCellView()
//}
