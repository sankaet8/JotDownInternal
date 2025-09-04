//
//  Thought.swift
//  JotDownInternal
//
//  Created by Rahul on 9/3/25.
//

import Foundation
import SwiftData

@Model
class Thought {
    var dateCreated = Date()
    var text: String

    init(text: String) {
        self.text = text
    }
}
