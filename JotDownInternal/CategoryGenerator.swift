//
//  CategoryGenerator.swift
//  JotDownInternal
//
//  Created by Rahul on 9/21/25.
//

import Foundation
import FoundationModels
import SwiftUI

class CategoryGenerator {
    enum CategoryGeneratorError: LocalizedError {
        case profileTextEmpty
    }

    func generateCategories(for profileText: String) async throws -> [Category] {
        guard !profileText.isEmpty else {
            throw CategoryGeneratorError.profileTextEmpty
        }

        let session = LanguageModelSession {
            """
            You are an expert assistant in an app which helps users take down
            quick notes and thoughts they have throughout the day (2-3 sentences).
            """

            "The app categorizes these notes automatically."
            "Categories are usually a word or two max."
            "You will help generate reasonable categories relevant to the user's profile."

            "Use concise, one- or two-word categories. Consider common personas like students, new parents, product managers, teachers, designers, engineers, runners, home cooks, indie devs, and grad researchers."

            "Example profiles and categories: "
            Category.exampleProfilesAndCategories
        }

        session.prewarm()

        let prompt = Prompt {
            "The user has described their profile as follows. Generate 5-8 note categories that are relevant to this profile."

            "User's Profile Description: " + profileText
        }

        return try await session
            .respond(to: prompt, generating: [Category].self).content
    }
}

extension Category {
    @Generable
    fileprivate struct ExampleProfile {
        let profile: String
        let categories: [Category]
    }

    fileprivate static let exampleProfilesAndCategories: [ExampleProfile] = [
        ExampleProfile(
            profile: "College student majoring in computer science, part-time barista, learning iOS development, likes running and cooking",
            categories: [
                Category(title: "Classes"),
                Category(title: "Coding"),
                Category(title: "Work Shift"),
                Category(title: "Fitness"),
                Category(title: "Meal Ideas"),
                Category(title: "Projects"),
                Category(title: "Exams")
            ]
        ),
        ExampleProfile(
            profile: "New parent juggling remote work, baby routines, and household chores; trying to get back into reading",
            categories: [
                Category(title: "Baby Care"),
                Category(title: "Work"),
                Category(title: "Household"),
                Category(title: "Groceries"),
                Category(title: "Sleep"),
                Category(title: "Reading"),
                Category(title: "Appointments")
            ]
        ),
        ExampleProfile(
            profile: "Senior product manager in fintech, focuses on roadmap planning, stakeholder updates, and team rituals; enjoys coffee and cycling",
            categories: [
                Category(title: "Roadmap"),
                Category(title: "Stakeholders"),
                Category(title: "Meetings"),
                Category(title: "Metrics"),
                Category(title: "Ideas"),
                Category(title: "Cycling"),
                Category(title: "Coffee")
            ]
        ),
        ExampleProfile(
            profile: "High school teacher (history) coaching debate; tracks lesson ideas, grading, and parent communication",
            categories: [
                Category(title: "Lessons"),
                Category(title: "Grading"),
                Category(title: "Debate"),
                Category(title: "Parent Comms"),
                Category(title: "Field Trips"),
                Category(title: "Resources"),
                Category(title: "Admin")
            ]
        ),
        ExampleProfile(
            profile: "Freelance designer traveling frequently; manages client briefs, invoices, and inspiration; practices yoga",
            categories: [
                Category(title: "Clients"),
                Category(title: "Briefs"),
                Category(title: "Invoices"),
                Category(title: "Inspiration"),
                Category(title: "Travel"),
                Category(title: "Portfolio"),
                Category(title: "Yoga")
            ]
        ),
        ExampleProfile(
            profile: "Software engineer into AI/ML, keeps track of papers to read, experiments, and conference deadlines; loves coffee",
            categories: [
                Category(title: "Papers"),
                Category(title: "Experiments"),
                Category(title: "Ideas"),
                Category(title: "Bugs"),
                Category(title: "Deadlines"),
                Category(title: "Talks"),
                Category(title: "Coffee")
            ]
        ),
        ExampleProfile(
            profile: "Fitness enthusiast training for a half marathon; tracks workouts, nutrition, recovery, and gear",
            categories: [
                Category(title: "Workouts"),
                Category(title: "Runs"),
                Category(title: "Nutrition"),
                Category(title: "Recovery"),
                Category(title: "Gear"),
                Category(title: "Progress"),
                Category(title: "Races")
            ]
        ),
        ExampleProfile(
            profile: "Home cook experimenting with vegetarian recipes; plans weekly menus and tracks pantry items",
            categories: [
                Category(title: "Recipes"),
                Category(title: "Meal Plan"),
                Category(title: "Groceries"),
                Category(title: "Pantry"),
                Category(title: "Prep"),
                Category(title: "Kitchen Gear"),
                Category(title: "Notes")
            ]
        ),
        ExampleProfile(
            profile: "Indie iOS developer building a habit tracker app; handles marketing, roadmap, and bug reports",
            categories: [
                Category(title: "Roadmap"),
                Category(title: "Marketing"),
                Category(title: "Bugs"),
                Category(title: "Features"),
                Category(title: "Feedback"),
                Category(title: "Launch"),
                Category(title: "Metrics")
            ]
        ),
        ExampleProfile(
            profile: "Graduate student in psychology conducting research; tracks study design, IRB, data collection, and writing",
            categories: [
                Category(title: "Study Design"),
                Category(title: "IRB"),
                Category(title: "Data Collection"),
                Category(title: "Analysis"),
                Category(title: "Writing"),
                Category(title: "Citations"),
                Category(title: "Deadlines")
            ]
        )
    ]
}
