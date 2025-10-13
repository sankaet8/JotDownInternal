//
//  JotDownAppShortcuts.swift
//  JotDownInternal
//
//  Created by Rahul on 9/30/25.
//

import AppIntents

struct JotDownAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NewThoughtAppIntent(),
            phrases: [
                "New thought in \(.applicationName)",
            ],
            shortTitle: "New Thought",
            systemImageName: "square.and.pencil"
        )
    }
}
