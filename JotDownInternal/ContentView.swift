//
//  ContentView.swift
//  JotDownInternal
//
//  Created by Sankaet Cheemalamarri on 9/3/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Thought.dateCreated, order: .reverse) var thoughts: [Thought]

    @State private var showingEntryView = true
    @State private var searchText = ""

    var filteredThoughts: [Thought] {
        if searchText.isEmpty {
            return thoughts
        } else {
            return thoughts.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search thoughts...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.top, .horizontal])

                List(filteredThoughts) { thought in
                    VStack(alignment: .leading) {
                        Text(thought.dateCreated, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(thought.text)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Thoughts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Thought", systemImage: "square.and.pencil") {
                        showingEntryView = true
                    }
                }
            }
            .sheet(isPresented: $showingEntryView) {
                NavigationStack {
                    ThoughtEntryView(onCompletion: addThought)
                }
                .presentationDetents([.medium])
            }
        }
    }

    @MainActor
    func addThought(text: String) {
        defer {
            showingEntryView = false
        }

        guard !text.isEmpty else { return }

        let thought = Thought(text: text)

        modelContext.insert(thought)
        try? modelContext.save()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Thought.self, inMemory: true)
}
