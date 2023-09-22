//
//  PSRegexValidator.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

enum PSRegexValidator {
    /// Evaluates string against the given regex pattern
    /// - Parameters:
    ///   - string: Evaluated string
    ///   - pattern: Regex pattern
    static func evaluate(string: String, pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: string)
    }
}

// MARK: - Regex patterns
extension String {
    /// Only digits regex pattern
    static let onlyDigitsRegexPattern = "[0-9]+"
}
