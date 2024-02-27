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
                .accentColor(Color("AccentOrange" ))
                .onAppear {
                    UITabBar.appearance().unselectedItemTintColor = UIColor(named: "TextSecondary")
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } // ZStack
        } // WindowGroup
    } // Scene
}
