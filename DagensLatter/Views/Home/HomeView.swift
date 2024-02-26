//
//  HomePageView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var isLoading: Bool = false
    @Environment(\.managedObjectContext) private var moc
    @State private var currentJokeResponse: JokeResponse?
    @State private var isFavorite: Bool = false
    @State private var showFavoriteMessage: Bool = false
    private var apiClient = APIClient.live
    
    var body: some View {
        VStack {
            Text("Laughter Of The Day")
                .font(.title)
                .padding(.top)
            Spacer()
            if isLoading {
                jokePlaceholderView
            } else {
                jokePresentationView()
            }
            
            if showFavoriteMessage {
                Text(isFavorite ? "Joke Favorited" : "Joke Unfavorited")
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showFavoriteMessage = false
                            }
                        }
                    }
            }
            
            Button("Get New Joke") {
                fetchJoke()
            }
            .buttonStyle(JokeButtonStyle(backgroundColor: Color.blue))
            .padding(.bottom)
            
            Spacer()
        }
        .onAppear {
            fetchJoke()
        }
    }
    
    private var jokePlaceholderView: some View {
        VStack {
            ProgressView()
            Text("Fetching a new joke...").padding()
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding()
    }
    
    private func fetchJoke() {
        isLoading = true
        isFavorite = false
        showFavoriteMessage = false
        Task {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                let response = try await apiClient.getRandomJoke()
                DispatchQueue.main.async {
                    self.currentJokeResponse = response.self
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error.localizedDescription)
            }
        }
    }
    
    @ViewBuilder
    private func jokePresentationView() -> some View {
        if let jokeResponse = currentJokeResponse {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(jokeResponse.category.uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(JokeManager.fullJokeTextAPI(for: jokeResponse))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
                    }
                    .padding([.leading, .top, .bottom], 10)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            JokeManager.saveJoke(response: jokeResponse, in: moc)
                            isFavorite.toggle()
                            showFavoriteMessage = true
                        }
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .padding(10)
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 200, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding()
        } else {
            jokePlaceholderView
        }
    }
}


struct JokeButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
