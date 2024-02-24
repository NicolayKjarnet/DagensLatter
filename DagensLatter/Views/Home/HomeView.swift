//
//  HomePageView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var jokeText: String? // Bruk en enkel String for å holde vitsen
    @State private var isLoading: Bool = false
    @Environment(\.managedObjectContext) private var moc
    @State private var currentFlagResponse: FlagResponse?
    
    // Fjernet FetchRequest siden vi ikke henter ikke-favoritt vitser her
    
    private var apiClient = APIClient.live
    
    var body: some View {
        VStack {
            if isLoading {
                VStack {
                    ProgressView()
                    Text("Producing new joke...").padding()
                }
            } else {
                Text(jokeText ?? "Fant ingen vits")
                    .padding()
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
                    saveJoke(flagResponse: currentFlagResponse!)
                }
                .disabled(jokeText == nil)
                .padding()
                .background(jokeText != nil ? Color.green : Color.gray)
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
                print(response)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.jokeText = response.joke // Oppdaterer vitsen
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
    
    func saveJoke(flagResponse: FlagResponse) {
        guard let jokeText = jokeText else { return }
        
        // Sjekk om vitsen allerede finnes i databasen
        let fetchRequest: NSFetchRequest<Joke> = Joke.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "joke == %@", jokeText)
        
        do {
            let results = try moc.fetch(fetchRequest)
            
            if let existingJoke = results.first {
                // Vitsen finnes allerede i databasen, oppdater flagget
                updateFlag(for: existingJoke, with: flagResponse)
            } else {
                // Vitsen finnes ikke, opprett ny vits og nytt flagg
                let newJoke = Joke(context: moc)
                newJoke.joke = jokeText
                newJoke.favorite = true
                newJoke.id = Int16.random(in: Int16.min...Int16.max)
                newJoke.dateSaved = Date()
                
                // Opprett og konfigurer Flag-objektet
                let newFlag = Flag(context: moc)
                newFlag.explicit = flagResponse.explicit
                newFlag.nsfw = flagResponse.nsfw
                newFlag.political = flagResponse.political
                newFlag.racist = flagResponse.racist
                newFlag.religious = flagResponse.religious
                newFlag.sexist = flagResponse.sexist
                // Assure a shared unique identifier if needed
                // newFlag.id = newJoke.id // Uncomment this line if you have a corresponding 'id' property in your Flag entity
                
                // Sett flagget til vitsen
                newJoke.flags = newFlag
                
                try moc.save()
//                JokeCounter.numberedStored += 1
            }
            
            try moc.save()
        } catch {
            print("Failed to save or update joke: \(error)")
        }
    }
    
    // Funksjon for å oppdatere flagget på en eksisterende vits
    func updateFlag(for joke: Joke, with flagResponse: FlagResponse) {
        if let flag = joke.flags {
            // Oppdater eksisterende flagg
            flag.explicit = flagResponse.explicit
            flag.nsfw = flagResponse.nsfw
            flag.political = flagResponse.political
            flag.racist = flagResponse.racist
            flag.religious = flagResponse.religious
            flag.sexist = flagResponse.sexist
        } else {
            // Opprett og konfigurer et nytt Flag-objekt hvis det ikke finnes
            let newFlag = Flag(context: moc)
            newFlag.explicit = flagResponse.explicit
            newFlag.nsfw = flagResponse.nsfw
            newFlag.political = flagResponse.political
            newFlag.racist = flagResponse.racist
            newFlag.religious = flagResponse.religious
            newFlag.sexist = flagResponse.sexist
            // Assure a shared unique identifier if needed
            // newFlag.id = joke.id // Uncomment this line if you have a corresponding 'id' property in your Flag entity
            
            // Sett det nye flagget til vitsen
            joke.flags = newFlag
        }
    }
}


//
//#Preview {
//    HomeView()
//}
