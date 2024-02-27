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
            Spacer()
            Text("Laughter Of The Day")
                .tint(Color("Text"))
                .font(.title)
                .padding(.top)
            HStack{
                Spacer()
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                Spacer()
            }
            Spacer()
            if isLoading {
                jokePlaceholderView
            } else {
                jokePresentationView()
            }
            
            if showFavoriteMessage {
                Text(isFavorite ? "Joke Favorited" : "Joke Unfavorited")
                    .tint(Color("Text"))
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
            .buttonStyle(JokeButtonStyle(backgroundColor: Color("AccentOrange" )))
            .fontWeight(.bold)
            .padding(.bottom)
            
            Spacer()
        }
        .onAppear {
            fetchJoke()
        }
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
                            .foregroundStyle(Color.gray)
                        Text(JokeManager.fullJokeTextAPI(for: jokeResponse))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.white)
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
                        Image(systemName: "heart.fill")
                            .foregroundColor(isFavorite ? Color("AccentOrange" ) : Color("SupportiveGray"))
                            .padding(20)
                            .padding(.bottom, 70)
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 200, alignment: .topLeading)
            .background(Color("Card"))
            .cornerRadius(12)
            .padding()
        } else {
            jokePlaceholderView
        }
    }
    
    private var jokePlaceholderView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color("AccentOrange")))
            Text("Generating a new joke...").padding()
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(Color("Card"))
        .cornerRadius(12)
        .padding()
    }
}
