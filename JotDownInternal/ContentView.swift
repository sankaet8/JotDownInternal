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
    @State private var showingProfileView = false

    var body: some View {
        NavigationStack {
            List(thoughts) { thought in
                VStack(alignment: .leading) {
                    Text(thought.dateCreated, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(thought.text)
                }
            }
            .navigationTitle("Thoughts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Thought", systemImage: "square.and.pencil") {
                        showingEntryView = true
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Settings", systemImage: "gear") {
                        showingProfileView = true
                    }
                }
            }
            .sheet(isPresented: $showingEntryView) {
                NavigationStack {
                    ThoughtEntryView(onCompletion: addThought)
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingProfileView) {
                ProfileView()
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
