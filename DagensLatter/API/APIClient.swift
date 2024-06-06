//
//  APIClient.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 23/02/2024.
//

import Foundation

struct APIClient {
    // MARK: - APIClient
    var getRandomJoke: (() async throws -> JokeResponse)
    
}

extension APIClient {
    // MARK: - Live Client Extension
    
    static let live = APIClient(
        getRandomJoke: {
            do {
                let url = URL(string: "https://v2.jokeapi.dev/joke/Any")!
                
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw APIClientError.statusCode((response as? HTTPURLResponse)?.statusCode ?? 500)
                }
                
                let joke = try JSONDecoder().decode(JokeResponse.self, from: data)
                
                return joke
            } catch {
                throw APIClientError.failed(underlying: error)
            }
        }
    )
}

// MARK: - Data Models
struct JokeResponse: Codable {
    let error: Bool
    let category: String
    let type: String
    let joke: String?
    let setup: String?
    let delivery: String?
    let flags: FlagResponse
    let id: Int
    let safe: Bool
    let lang: String
    let comments: String?
    let dateSaved: Date?
    let rating: Int?
    let userCreated: Bool?
}

struct FlagResponse: Codable {
    let nsfw: Bool
    let religious: Bool
    let political: Bool
    let racist: Bool
    let sexist: Bool
    let explicit: Bool
}

struct JokeInputData {
    let id: Int16
    let category: String
    let type: String
    let joke: String?
    let setup: String?
    let delivery: String?
    let flags: FlagResponse
}

// MARK: - Errors

enum APIClientError: Error {
    case failed(underlying: Error)
    case statusCode(Int)
    case unknown
}
