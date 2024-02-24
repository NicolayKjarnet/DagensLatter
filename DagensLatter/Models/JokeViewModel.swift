//
//  GetRandomJoke.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 23/02/2024.
//

import Foundation
import CoreData

class JokeViewModel: ObservableObject {
    @Published var joke: String = ""
    @Published var isLoading: Bool = false
    private var apiClient = APIClient.live
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchJoke() {
        isLoading = true
        joke = ""
        Task {
            do {
                let response = try await apiClient.getRandomJoke()
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.joke = response.joke ?? "Joke not available"
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.joke = "Failed to fetch joke"
                }
                print(error)
            }
        }
    }

    func saveJoke() {
        // Sjekk om vitsen allerede finnes i databasen
        let fetchRequest: NSFetchRequest<Joke> = Joke.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "joke == %@", self.joke)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingJoke = results.first {
                // Vitsen finnes allerede i databasen, setter bare 'favorite' til true
                existingJoke.favorite = true
            } else {
                // Vitsen finnes ikke, opprett ny vits
                let newJoke = Joke(context: context)
                newJoke.joke = self.joke
                newJoke.favorite = true
                newJoke.id = Int16.random(in: Int16.min...Int16.max)
                newJoke.dateSaved = Date()
            }
            try context.save()
        } catch {
            print("Failed to save or update joke: \(error)")
        }
    }
}
