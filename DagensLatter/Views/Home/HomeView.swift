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
    @State private var currentFlagResponse: FlagResponse?
    @State private var currentJokeResponse: JokeResponse?
    private var apiClient = APIClient.live
    
    var body: some View {
        VStack {
            if isLoading {
                VStack {
                    ProgressView()
                    Text("Producing new joke...").padding()
                }
            } else {
                if currentJokeResponse?.type == "twopart", let setup = currentJokeResponse?.setup, let delivery = currentJokeResponse?.delivery {
                    Text(setup)
                        .padding(.vertical, 2)
                    Text(delivery)
                        .padding()
                } else if let joke = currentJokeResponse?.joke {
                    Text(joke)
                        .padding()
                }
            }
            HStack {
                Button("Get New Joke") {
                    fetchJoke()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Save to favorite") {
                    if let jokeResponse = currentJokeResponse {
                        JokeManager.saveJoke(response: jokeResponse, in: moc)
                    }
                }
                .disabled(currentJokeResponse == nil)
                .padding()
                .background(currentJokeResponse != nil ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            fetchJoke()
        }
    }
    
    func fetchJoke() {
        isLoading = true
        Task {
            do {
                let response = try await apiClient.getRandomJoke()
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.currentJokeResponse = response.self
                    self.currentFlagResponse = response.flags
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
    }
}


#Preview {
    HomeView()
}
