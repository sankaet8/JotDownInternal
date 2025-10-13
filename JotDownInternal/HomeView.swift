//
//  HomeView.swift
//  JotDownInternal
//
//  Created by Rahul on 10/13/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var thoughtListManager = ThoughtListManager()

    var body: some View {
        VStack {
            Header()
            ThoughtListView()
            Footer()
        }
        .padding()
        .environment(thoughtListManager)
        .background {
            LinearGradient(
                colors: [.bg, .bg2, .bg3],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        .environment(\.colorScheme, .light)
    }
}

private struct Header: View {
    @Environment(ThoughtListManager.self) var thoughtListManager

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            JotDownLogo()
                .foregroundStyle(.white)
            Spacer()
            Button("Add Thought", systemImage: "plus") {
                withAnimation {
                    thoughtListManager.selectedThought = .newThought
                }
            }
            .imageScale(.large)
            .labelStyle(.iconOnly)
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
        }
    }
}

private struct Footer: View {
    @Environment(ThoughtListManager.self) var thoughtListManager

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    private var dateString: String {
        guard case .thought(let thought) = thoughtListManager.selectedThought else {
            return "Today"
        }

        return dateFormatter.string(from: thought.dateCreated)
    }

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text(dateString)
                    .font(.title)
                    .contentTransition(.numericText())

                Text("date")
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
        .animation(.default, value: thoughtListManager.selectedThought)
        .foregroundStyle(.white)
    }
}

#Preview {
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
    
    return HomeView()
}
