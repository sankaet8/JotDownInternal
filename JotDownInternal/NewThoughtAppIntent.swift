//
//  NewThoughtAppIntent.swift
//  JotDownInternal
//
//  Created by Rahul on 9/30/25.
//

import AppIntents
import SwiftData
import SwiftUI

struct NewThoughtAppIntent: AppIntent {
    static let title: LocalizedStringResource = "New Thought"

    @Dependency var modelContainer: ModelContainer

    @AppStorage("com.jotdown.categories") var categoriesValue = StorageValue<[Category]>([])

    @Parameter(
        title: "Thought",
        requestValueDialog: "What's on your mind?"
    )
    var thoughtText: String

    func perform() async throws -> some IntentResult {
        let categorizer = await Categorizer(
            categories: categoriesValue.value ?? []
        )

        let thought = Thought(text: thoughtText)

        let category = try? await categorizer.categorize(thought: thought)

        thought.category = category

        let modelContext = await modelContainer.mainContext

        modelContext.insert(thought)
        try? modelContext.save()

        return .result()
    }
}
