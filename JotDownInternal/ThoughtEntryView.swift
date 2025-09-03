//
//  ThoughtEntryView.swift
//  JotDownInternal
//
//  Created by Rahul on 9/3/25.
//

import SwiftUI

struct ThoughtEntryView: View {
    @Environment(\.dismiss) var dismiss

    @State private var entryText = ""
    @FocusState private var isFocused: Bool

    var onCompletion: (String) -> Void = { _ in }

    var body: some View {
        TextField(
            "What's on your mind?",
            text: $entryText,
            axis: .vertical
        )
        .focused($isFocused)
        .font(.largeTitle)
        .fontDesign(.serif)
        .padding(16)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    onCompletion(entryText)
                }
            }
        }
        .task {
            isFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        ThoughtEntryView()
    }
}
