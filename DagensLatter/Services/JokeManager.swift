//
//  JokeManager.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 24/02/2024.
//

import Foundation
import CoreData
import SwiftUI

struct JokeManager {
    
    // MARK: - Save Joke
    static func saveJoke(response: JokeResponse, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Joke> = Joke.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", Int16(response.id))
        
        do {
            let results = try context.fetch(fetchRequest)
            let joke: Joke
            
            if let existingJoke = results.first {
                joke = existingJoke
            } else {
                joke = Joke(context: context)
                joke.id = Int16(response.id)
                joke.favorite = false
                joke.dateSaved = Date()
            }
            
            joke.category = response.category
            joke.lang = response.lang
            joke.safe = response.safe
            joke.type = response.type
            
            if response.type == "single" {
                joke.joke = response.joke
                joke.setup = nil
                joke.delivery = nil
            } else if response.type == "twopart" {
                joke.setup = response.setup
                joke.delivery = response.delivery
                joke.joke = nil
            }
            
            updateFlag(for: joke, with: response, in: context)
            
            try context.save()
        } catch {
            print("Failed to save joke: \(error)")
        }
    }
    
    // MARK: - Update Flag
    static func updateFlag(for joke: Joke, with response: JokeResponse, in context: NSManagedObjectContext) {
        if let existingFlags = joke.flags {
            existingFlags.nsfw = response.flags.nsfw
            existingFlags.religious = response.flags.religious
            existingFlags.explicit = response.flags.explicit
            existingFlags.political = response.flags.political
            existingFlags.racist = response.flags.racist
            existingFlags.sexist = response.flags.sexist
        } else {
            let newFlags = Flag(context: context)
            newFlags.nsfw = response.flags.nsfw
            newFlags.religious = response.flags.religious
            newFlags.explicit = response.flags.explicit
            newFlags.political = response.flags.political
            newFlags.racist = response.flags.racist
            newFlags.sexist = response.flags.sexist
            joke.flags = newFlags
        }
    }
    
    // MARK: - Fetch Saved Jokes Count
    static func fetchSavedJokesCount(in context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<Joke> = Joke.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Failed to fetch saved jokes count: \(error)")
            return 0
        }
    }
    
    // MARK: - Create Or Update Joke
    static func createOrUpdateJoke(with jokeData: JokeInputData, in context: NSManagedObjectContext) {
        let joke: Joke
        let fetchRequest: NSFetchRequest<Joke> = Joke.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", jokeData.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingJoke = results.first {
                joke = existingJoke
            } else {
                joke = Joke(context: context)
                joke.id = Int16(jokeData.id)
            }
            
            joke.category = jokeData.category
            joke.joke = jokeData.joke
            joke.setup = jokeData.setup
            joke.delivery = jokeData.delivery
            joke.dateSaved = Date()
            
            let flagEntity = Flag(context: context)
            flagEntity.nsfw = jokeData.flags.nsfw
            flagEntity.religious = jokeData.flags.religious
            flagEntity.political = jokeData.flags.political
            flagEntity.racist = jokeData.flags.racist
            flagEntity.sexist = jokeData.flags.sexist
            flagEntity.explicit = jokeData.flags.explicit
            joke.flags = flagEntity
            
            try context.save()
        } catch {
            print("Failed to create or update joke: \(error)")
        }
    }
    
    // MARK: - Delete Joke
    static func deleteJoke(joke: Joke, context: NSManagedObjectContext) {
        context.delete(joke)
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Delete Joke In List
    static func deleteJokeInList(at offsets: IndexSet, from jokes: FetchedResults<Joke>, in context: NSManagedObjectContext) {
        offsets.forEach { index in
            let joke = jokes[index]
            context.delete(joke)
        }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func deleteJokeInArray(at jokes: [Joke], context: NSManagedObjectContext) {
        for joke in jokes {
            context.delete(joke)
        }
        try? context.save()
    }
    
    // MARK: - Full Joke Text
    static func fullJokeText(for joke: Joke) -> String {
        switch joke.type {
        case "single":
            return joke.joke ?? "Unknown Joke"
        case "twopart":
            let setup = joke.setup ?? "Unknown Setup"
            let delivery = joke.delivery ?? "Unknown Delivery"
            return "\(setup)\n\(delivery)"
        default:
            return "Unknown Joke Type"
        }
    }
    
    // MARK: - Full Joke Text For Network Call
    static func fullJokeTextAPI(for joke: JokeResponse) -> String {
        switch joke.type {
        case "single":
            return joke.joke ?? "Unknown Joke"
        case "twopart":
            let setup = joke.setup ?? "Unknown Setup"
            let delivery = joke.delivery ?? "Unknown Delivery"
            return "\(setup)\n\(delivery)"
        default:
            return "Unknown Joke Type"
        }
    }
}
