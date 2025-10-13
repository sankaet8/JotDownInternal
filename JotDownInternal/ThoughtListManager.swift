//
//  ThoughtListManager.swift
//  JotDownInternal
//
//  Created by Rahul on 10/13/25.
//

import SwiftData
import SwiftUI

@Observable
class ThoughtListManager {
    static let thoughtCardRadius: CGFloat = 29
    enum Selection: Hashable {
        case newThought
        case thought(Thought)
    }

    var selectedThought: Selection?

    @discardableResult
    func addThought(
        text: String,
        categories: [Category],
        context: ModelContext
    ) async throws -> Thought? {
        guard !text.isEmpty else { return nil }

        let categorizer = Categorizer(categories: categories)

        let thought = Thought(text: text)

        let category = try? await categorizer.categorize(thought: thought)

        thought.category = category

        context.insert(thought)
        try? context.save()

        return thought
    }
}
