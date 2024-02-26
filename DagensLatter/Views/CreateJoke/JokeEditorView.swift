////
////  JokeEditorView.swift
////  DagensLatter
////
////  Created by Nicolay Kjærnet on 26/02/2024.
////
//
//import SwiftUI
//
//// MARK: - Joke Editor View
//struct JokeEditorView: View {
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
//    @State private var showingConfirmation = false
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
//        Form {
//            CategoryPicker(selectedCategory: $selectedCategory, categories: categories)
//            JokeTypePicker(jokeType: $jokeType)
//            if jokeType == "twopart" {
//                TextField("Setup", text: $setup)
//                TextField("Delivery", text: $delivery)
//            } else {
//                TextField("Joke", text: $jokeContent)
//            }
//            JokeFlagsSection(nsfw: $nsfw, religious: $religious, political: $political, racist: $racist, sexist: $sexist, explicit: $explicit)
//        }
//        .navigationBarTitle(jokeToEdit == nil ? "New Joke" : "Edit Joke", displayMode: .inline)
//        .navigationBarItems(leading: Button("Cancel") {
//            presentationMode.wrappedValue.dismiss()
//        }, trailing: Button("Submit") {
//            let jokeData = JokeInputData(
//                id: jokeToEdit?.id ?? 0,
//                category: selectedCategory, type: jokeType,
//                joke: jokeType == "single" ? jokeContent : nil,
//                setup: jokeType == "twopart" ? setup : nil,
//                delivery: jokeType == "twopart" ? delivery : nil,
//                flags: FlagResponse(
//                    nsfw: nsfw,
//                    religious: religious,
//                    political: political,
//                    racist: racist,
//                    sexist: sexist,
//                    explicit: explicit
//                )
//            )
//            JokeManager.createOrUpdateJoke(with: jokeData, in: moc)
//            showingConfirmation = true // If you want to show a confirmation alert after saving
//            presentationMode.wrappedValue.dismiss()
//        }.disabled(!isFormValid))
//        .alert(isPresented: $showingConfirmation) {
//            Alert(title: Text("Confirmation"), message: Text(jokeToEdit != nil ? "Joke updated!" : "Joke added!"), dismissButton: .default(Text("OK")))
//        }
//        .onAppear {
//            self.loadJokeData()
//        }
//    } // MARK: - View
//        
//        func loadJokeData() {
//            guard let joke = jokeToEdit else { return }
//            jokeType = joke.type ?? "single"
//            setup = joke.setup ?? ""
//            delivery = joke.delivery ?? ""
//            jokeContent = joke.joke ?? ""
//            selectedCategory = joke.category ?? "General"
//            nsfw = joke.flags?.nsfw ?? false
//            religious = joke.flags?.religious ?? false
//            political = joke.flags?.political ?? false
//            racist = joke.flags?.racist ?? false
//            sexist = joke.flags?.sexist ?? false
//            explicit = joke.flags?.explicit ?? false
//        }
//}
//
//// MARK: - Category Picker View
//   struct CategoryPicker: View {
//       @Binding var selectedCategory: String
//       var categories: [String]
//       
//       var body: some View {
//           Picker("Select a category", selection: $selectedCategory) {
//               ForEach(categories, id: \.self) { category in
//                   Text(category).tag(category)
//               }
//           }
//           .pickerStyle(MenuPickerStyle())
//       }
//   }
//   
//   // MARK: - Joke Type Picker View
//   struct JokeTypePicker: View {
//       @Binding var jokeType: String
//       let jokeTypes = ["single", "twopart"]
//       
//       var body: some View {
//           Picker("Type", selection: $jokeType) {
//               ForEach(jokeTypes, id: \.self) { type in
//                   Text(type.capitalized).tag(type)
//               }
//           }
//           .pickerStyle(SegmentedPickerStyle())
//       }
//   }
//   
//   // MARK: - Joke Flags Section View
//struct JokeFlagsSection: View {
//    @Binding var nsfw: Bool
//    @Binding var religious: Bool
//    @Binding var political: Bool
//    @Binding var racist: Bool
//    @Binding var sexist: Bool
//    @Binding var explicit: Bool
//    
//    var body: some View {
//        Section(header: Text("Flags")) {
//            Toggle("NSFW", isOn: $nsfw)
//            Toggle("Religious", isOn: $religious)
//            Toggle("Political", isOn: $political)
//            Toggle("Racist", isOn: $racist)
//            Toggle("Sexist", isOn: $sexist)
//            Toggle("Explicit", isOn: $explicit)
//        }
//    }
//}
