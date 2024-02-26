//
//  JokeListView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 25/02/2024.
//

// MARK: - FUNGERER NESTEN #1
//import SwiftUI
//import CoreData
//
//struct UserCreatedJokesListView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.managedObjectContext) private var moc
//    @State private var jokeType: String = "single"
//    @State private var setup: String = ""
//    @State private var delivery: String = ""
//    @State private var jokeContent: String = ""
//    @State private var selectedCategory: String = "General"
//    private let categories = ["General", "Programming", "Misc", "Pun", "Spooky", "Christmas"]
//    @Binding var jokeToEdit: Joke?
//
//    @State private var nsfw = false
//    @State private var religious = false
//    @State private var political = false
//    @State private var racist = false
//    @State private var sexist = false
//    @State private var explicit = false
//
//    @FetchRequest(
//        entity: Joke.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.dateSaved, ascending: false)]
//    ) var jokes: FetchedResults<Joke>
//
//    var isFormValid: Bool {
//        if jokeType == "twopart" {
//            return !setup.isEmpty && !delivery.isEmpty && !selectedCategory.isEmpty
//        } else {
//            return !jokeContent.isEmpty && !selectedCategory.isEmpty
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Category")) {
//                    Picker("Select a category", selection: $selectedCategory) {
//                        ForEach(categories, id: \.self) { category in
//                            Text(category).tag(category)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                }
//
//                Section(header: Text("Joke Type")) {
//                    Picker("Type", selection: $jokeType) {
//                        Text("Single").tag("single")
//                        Text("Two Part").tag("twopart")
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                }
//
//                // Include your joke text fields and toggle switches here
//                if jokeType == "twopart" {
//                    TextField("Setup", text: $setup)
//                    TextField("Delivery", text: $delivery)
//                } else {
//                    TextField("Joke", text: $jokeContent)
//                }
//
//                Section(header: Text("Flags")) {
//                    Toggle("NSFW", isOn: $nsfw)
//                    Toggle("Religious", isOn: $religious)
//                    Toggle("Political", isOn: $political)
//                    Toggle("Racist", isOn: $racist)
//                    Toggle("Sexist", isOn: $sexist)
//                    Toggle("Explicit", isOn: $explicit)
//                }
//
//                // Existing jokes list
//                Section(header: Text("Your Jokes")) {
//                    List {
//                        ForEach(jokes) { joke in
//                            Text(JokeManager.fullJokeText(for: joke))
//                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                    Button(role: .destructive) {
//                                        JokeManager.deleteJoke(joke: joke, context: moc)
//                                    } label: {
//                                        Label("Delete", systemImage: "trash")
//                                    }
//                                }
//                        }
//                        .onDelete(perform: deleteJoke)
//                    }
//                }
//            }
//            .navigationBarTitle(jokeToEdit == nil ? "New Joke" : "Edit Joke", displayMode: .inline)
//            .navigationBarItems(leading: Button("Cancel") {
//                presentationMode.wrappedValue.dismiss()
//            }, trailing: Button("Submit") {
//                createOrUpdateJoke()
//                presentationMode.wrappedValue.dismiss()
//            }.disabled(!isFormValid))
//        }
//        .onAppear {
//            loadJokeData()
//        }
//    }
//
//    private func createOrUpdateJoke() {
//        let jokeData = JokeInputData(
//            id: jokeToEdit?.id ?? Int16.random(in: 0...Int16.max),
//            category: selectedCategory,
//            type: jokeType,
//            joke: jokeContent,
//            setup: setup,
//            delivery: delivery,
//            flags: FlagResponse(nsfw: nsfw, religious: religious, political: political, racist: racist, sexist: sexist, explicit: explicit)
//        )
//        JokeManager.createOrUpdateJoke(with: jokeData, in: moc)
//    }
//
//    private func loadJokeData() {
//        // Load joke data if editing
//        if let joke = jokeToEdit {
//            jokeType = joke.type ?? "single"
//            setup = joke.setup ?? ""
//            delivery = joke.delivery ?? ""
//            jokeContent = joke.joke ?? ""
//            selectedCategory = joke.category ?? "General"
//
//            nsfw = joke.flags?.nsfw ?? false
//            religious = joke.flags?.religious ?? false
//            political = joke.flags?.political ?? false
//            racist = joke.flags?.racist ?? false
//            sexist = joke.flags?.sexist ?? false
//            explicit = joke.flags?.explicit ?? false
//        }
//    }
//
//    private func deleteJoke(at offsets: IndexSet) {
//        withAnimation {
//            offsets.map { jokes[$0] }.forEach(moc.delete)
//            do {
//                try moc.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}

// MARK: - FUNKER NESTEN, men mangler litt funksjonalitet i lister:
// 1. Listen i viser feil vits eller noen ganger den samme vitsen flere ganger i stedet for å liste opp alle
// 2. Oppdaterer ikke listen omgående når man redigerer en vits

import SwiftUI
import CoreData

struct UserCreatedJokesListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var moc
    @State private var jokeType: String = "single"
    @State private var setup: String = ""
    @State private var delivery: String = ""
    @State private var jokeContent: String = ""
    @State private var selectedCategory: String = "General"
    private let categories = ["General", "Programming", "Misc", "Pun", "Spooky", "Christmas"]
    @Binding var jokeToEdit: Joke?
    
    @State private var nsfw = false
    @State private var religious = false
    @State private var political = false
    @State private var racist = false
    @State private var sexist = false
    @State private var explicit = false
    
    var onDismiss: () -> Void = {}
    
    @State private var showingConfirmation = false
    
    var isFormValid: Bool {
        if jokeType == "twopart" {
            return !setup.isEmpty && !delivery.isEmpty && !selectedCategory.isEmpty
        } else {
            return !jokeContent.isEmpty && !selectedCategory.isEmpty
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category")) {
                    Picker("Select a category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Joke Type")) {
                    Picker("Type", selection: $jokeType) {
                        Text("Single").tag("single")
                        Text("Two Part").tag("twopart")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if jokeType == "twopart" {
                    TextField("Setup", text: $setup)
                    TextField("Delivery", text: $delivery)
                } else {
                    TextField("Joke", text: $jokeContent)
                }
                
                Section(header: Text("Flags")) {
                    Toggle("NSFW", isOn: $nsfw)
                    Toggle("Religious", isOn: $religious)
                    Toggle("Political", isOn: $political)
                    Toggle("Racist", isOn: $racist)
                    Toggle("Sexist", isOn: $sexist)
                    Toggle("Explicit", isOn: $explicit)
                }
            } // MARK: - Form
            .navigationBarTitle(jokeToEdit == nil ? "New Joke" : "Edit Joke", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveJoke()
            }.disabled(!isFormValid))
            .alert(isPresented: $showingConfirmation) {
                Alert(title: Text("Confirmation"), message: Text(jokeToEdit != nil ? "Joke updated!" : "Joke added!"), dismissButton: .default(Text("OK")))
            }
        } // MARK: - NavigationView
        .onAppear {
            loadJokeData()
        }
    }
    
    private func saveJoke() {
        let joke = jokeToEdit ?? Joke(context: moc)
        joke.type = jokeType
        joke.setup = jokeType == "twopart" ? setup : nil
        joke.delivery = jokeType == "twopart" ? delivery : nil
        joke.joke = jokeType == "single" ? jokeContent : nil
        joke.category = selectedCategory
        joke.dateSaved = Date()
        joke.userCreated = true // Ensure this attribute is marked as user-created
        
        // Update or create new Flags entity as needed
        let flag = joke.flags ?? Flag(context: moc)
        flag.nsfw = nsfw
        flag.religious = religious
        flag.political = political
        flag.racist = racist
        flag.sexist = sexist
        flag.explicit = explicit
        joke.flags = flag
        
        do {
            try moc.save()
            showingConfirmation = true
            onDismiss()
        } catch {
            print("Error saving the joke: \(error.localizedDescription)")
        }
        presentationMode.wrappedValue.dismiss()
}

private func loadJokeData() {
    if let joke = jokeToEdit {
        jokeType = joke.type ?? "single"
        setup = joke.setup ?? ""
        delivery = joke.delivery ?? ""
        jokeContent = joke.joke ?? ""
        selectedCategory = joke.category ?? "General"
        nsfw = joke.flags?.nsfw ?? false
        religious = joke.flags?.religious ?? false
        political = joke.flags?.political ?? false
        racist = joke.flags?.racist ?? false
        sexist = joke.flags?.sexist ?? false
        explicit = joke.flags?.explicit ?? false
    }
}
}
