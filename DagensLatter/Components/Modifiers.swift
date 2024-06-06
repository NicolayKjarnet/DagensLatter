//
//  Modifiers.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 27/02/2024.
//

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color("PrimaryWhite")
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct JokeButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}



struct StarRatingStyle: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(star <= rating ? Color("AccentOrange" ) : Color("SupportiveGray"))
                    .onTapGesture {
                        rating = star
                    }
            }
        }
    }
}

struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("Text"))
    }
}


struct JokeCellView: View {
    let joke: Joke
    
    var body: some View {
        HStack {
            Text(JokeManager.fullJokeText(for: joke))
            Spacer()
            Text(joke.category ?? "Unknown")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }
}

struct EmptyPlaceholderModifier<Data>: ViewModifier where Data: RandomAccessCollection {
    var data: Data
    var message: String
    var image: Image
    
    func body(content: Content) -> some View {
        Group {
            if data.isEmpty {
                VStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Text(message)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .lineSpacing(5)
                        .padding()
                }
            } else {
                content
            }
        }
    }
}

extension View {
    func emptyPlaceholder<Data>(when data: Data, message: String, image: Image) -> some View where Data: RandomAccessCollection {
        modifier(EmptyPlaceholderModifier(data: data, message: message, image: image))
    }
}

struct RatingPickerItemView: View {
    var rating: Int16
    var selectedRating: Int16?
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(selectedRating == rating ? Color("AccentOrange") : Color("SecondaryText"))
            }
            
        }
    }
}

