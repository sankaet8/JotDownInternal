//
//  JotDownInternalApp.swift
//  JotDownInternal
//
//  Created by Sankaet Cheemalamarri on 9/3/25.
//

import AppIntents
import SwiftData
import SwiftUI

@main
struct JotDownInternalApp: App {
    let container: ModelContainer

    init() {
        let container = try! ModelContainer(for: Thought.self, configurations: .init())
        self.container = container

        AppDependencyManager.shared.add(dependency: container)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
