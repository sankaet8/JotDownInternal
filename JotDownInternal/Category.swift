//
//  Category.swift
//  JotDownInternal
//
//  Created by Rahul on 9/21/25.
//

import Foundation
import FoundationModels

@Generable
struct Category: Identifiable, Hashable, Codable {
    var id = UUID()
    let title: String
}
