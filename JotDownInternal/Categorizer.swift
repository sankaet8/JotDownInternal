//
//  Categorizer.swift
//  JotDownInternal
//
//  Created by Rahul on 9/21/25.
//

import Foundation
import FoundationModels

class Categorizer {
    let categories: [Category]

    init(categories: [Category]) {
        self.categories = categories
    }

    func categorize(thought: Thought) async throws -> Category {
        let session = LanguageModelSession {
            """
            You are an expert assistant in an app which helps users take down
            quick notes and thoughts they have throughout the day (2-3 sentences).
            """

            "You will help categorize a given note into one of the provided categories."

            "Only if you're unsure about the category, use 'other' as the response."

            "You will be given a set of Category objects with id's and titles."
            "When returning a response, use the exact id and title as the given options."
        }

        let prompt = Prompt {
            "The user has the following note: "
            thought.text

            "Categorize the note into one of the following categories: "
            categories
        }

        return try await session
            .respond(to: prompt, generating: Category.self).content
    }
}
