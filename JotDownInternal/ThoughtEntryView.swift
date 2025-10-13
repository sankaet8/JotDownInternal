//
//  ThoughtEntryView.swift
//  JotDownInternal
//
//  Created by Rahul on 9/3/25.
//

import SwiftUI

struct ThoughtEntryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ThoughtListManager.self) var thoughtListManager

    @State private var entryText = ""
    @State private var isLoading = false
    @FocusState private var isFocused: Bool

    @AppStorage("com.jotdown.categories") var categoriesValue = StorageValue<[Category]>([])

    var body: some View {
        VStack {
            HStack {
                Spacer()
                if !entryText.isEmpty {
                    Button(role: .confirm) {
                        Task {
                            isLoading = true
                            let newThought = try await thoughtListManager
                                .addThought(
                                    text: entryText,
                                    categories: categoriesValue.value ?? [],
                                    context: modelContext
                                )

                            withAnimation {
                                if let newThought {
                                    thoughtListManager.selectedThought =
                                        .thought(newThought)
                                }
                            }

                            entryText.removeAll()

                            isLoading = false
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "checkmark")
                        }
                    }
                    .disabled(isLoading || entryText.isEmpty)
                }
            }

            Spacer()

            TextField(
                "Start writing...",
                text: $entryText,
                axis: .vertical
            )
            .focused($isFocused)
            .font(.largeTitle)
            .fontDesign(.serif)

            Spacer()
        }
        .padding()
        .glassEffect(
            in: .rect(cornerRadius: ThoughtListManager.thoughtCardRadius)
        )
        .padding()
    }
}
