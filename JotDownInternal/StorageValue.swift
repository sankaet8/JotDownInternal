//
//  StorageValue.swift
//  JotDownInternal
//
//  Created by Rahul on 9/21/25.
//

// Adapted from https://danielsaidi.com/blog/2023/08/23/storing-codable-types-in-swiftui-appstorage

import Foundation

public struct StorageValue<Value: Codable>: RawRepresentable {

    /// Create a storage value.
    public init(_ value: Value? = nil) {
        self.value = value
    }

    /// Create a storage value with a JSON encoded string.
    public init?(rawValue: String) {
        guard
            let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(Value.self, from: data)
        else { return nil }
        self = .init(result)
    }

    /// The stored value.
    public var value: Value?
}

public extension StorageValue {

    /// Whether the storage value contains an actual value.
    var hasValue: Bool {
        value != nil
    }

    /// A JSON string representation of the storage value.
    var jsonString: String {
        guard
            let data = try? JSONEncoder().encode(value),
            let result = String(data: data, encoding: .utf8)
        else { return "" }
        return result
    }

    /// A JSON string representation of the storage value.
    var rawValue: String {
        jsonString
    }
}
