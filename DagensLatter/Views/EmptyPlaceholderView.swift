//
//  EmptyPlaceholderView.swift
//  DagensLatter
//
//  Created by Nicolay Kjærnet on 25/02/2024.
//

import SwiftUI

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
