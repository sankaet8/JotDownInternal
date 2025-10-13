//
//  ThoughtListView.swift
//  JotDownInternal
//
//  Created by Rahul on 10/13/25.
//

import SwiftData
import SwiftUI

struct ThoughtListView: View {
    @Environment(ThoughtListManager.self) var thoughtListManager
    @Query(sort: \Thought.dateCreated, order: .reverse) var thoughts: [Thought]

    var body: some View {
        @Bindable var thoughtListManager = thoughtListManager

        ScrollView(.horizontal) {
            LazyHStack(spacing: 8) {
                Group {
                    ThoughtEntryView()
                        .id(ThoughtListManager.Selection.newThought)

                    ForEach(thoughts) { thought in
                        ThoughtCard(thought: thought)
                            .id(ThoughtListManager.Selection.thought(thought))
                    }
                }
                .containerRelativeFrame(.horizontal, alignment: .center) { length, axis in
                    length * 0.9
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $thoughtListManager.selectedThought)
        .scrollClipDisabled()
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ThoughtCard: View {
    let thought: Thought

    var body: some View {
        VStack(alignment: .leading) {
            Text(thought.text)
                .font(.title)

            Spacer()

            HStack {
                Text(thought.dateCreated, style: .time)

                Spacer()

                if let category = thought.category {
                    Text(category.title)
                }
            }
        }
        .padding()
        .foregroundStyle(.secondary)
        .glassEffect(
            in: .rect(cornerRadius: ThoughtListManager.thoughtCardRadius)
        )
        .padding()
    }
}

#Preview("Seeded Thoughts") {
    // Create an in-memory model container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Thought.self, configurations: config)

    // Seed mock thoughts (run once per preview init)
    let context = container.mainContext

    // Optional: create a couple of mock categories if Category type exists
    // Comment out if Category isn't a SwiftData model in this target
    let workCategory: Category? = {
        // If Category is a SwiftData model with init(title:), this will work.
        // Otherwise, set to nil to avoid compile errors.
        if let category = try? Category(title: "Work") { return category }
        return nil
    }()
    let lifeCategory: Category? = {
        if let category = try? Category(title: "Life") { return category }
        return nil
    }()

    let thoughts: [Thought] = {
        var items: [Thought] = []
        let samples: [(String, Category?)] = [
            ("Sketching feature ideas for the notes app.", workCategory),
            ("Remember to buy coffee beans.", lifeCategory),
            ("Reflecting on today's meeting — focus on clarity.", workCategory),
            ("Read a chapter of the design book tonight.", nil)
        ]
        for (text, category) in samples {
            let t = Thought(text: text)
            t.category = category
            items.append(t)
        }
        return items
    }()

    for t in thoughts { context.insert(t) }
    try? context.save()

    return ThoughtListView()
        .modelContainer(container)
        .environment(ThoughtListManager())
}
