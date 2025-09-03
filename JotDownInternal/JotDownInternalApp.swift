//
//  JotDownInternalApp.swift
//  JotDownInternal
//
//  Created by Sankaet Cheemalamarri on 9/3/25.
//

import SwiftData
import SwiftUI

@main
struct JotDownInternalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Thought.self)
        }
    }
}
