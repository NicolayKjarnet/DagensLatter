//
//  DagensLatterApp.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 23/02/2024.
//

import SwiftUI

@main
struct DagensLatterApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                TabView{
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "theatermasks.fill")
                        }
                    SavedJokesView()
                        .tabItem {
                            Label("Saved Jokes", systemImage: "heart.square.fill")
                        }
                    RatedJokesView()
                        .tabItem {
                            Label("Rated Jokes", systemImage: "star.square")
                        }
                    CreateOrEditJokeListView()
                        .tabItem {
                            Label("Create Joke", systemImage: "pencil.tip.crop.circle.fill")
                        }
                } // TabView
                .onAppear {
                    getDocumentsDirectory()
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } // ZStack
        } // WindowGroup
    } // Scene
    
    func getDocumentsDirectory() {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            
            // Navigate one directory up from the Documents directory
            let parentDirectory = documentsDirectory.deletingLastPathComponent()
            print("Directory: \(parentDirectory)")
        }
}
