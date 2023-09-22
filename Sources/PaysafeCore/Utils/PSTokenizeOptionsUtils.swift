//
//  PSTokenizeOptionsUtils.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// PSTokenizeOptionsUtils
enum PSTokenizeOptionsUtils {
    /// Check if amount is greater than 0 and has no more than 11 characters.
    ///
    /// - Parameters:
    ///   - amount: Payment amount
    static func isValidAmount(_ amount: Int) -> Bool {
        amount > 0 && amount < 1_000_000_000
    }

    /// Check if value is not empty and has no more than 20 characters.
    ///
    /// - Parameters:
    ///   - dynamicDescriptor: Dynamic descriptor
    static func isValidDynamicDescriptor(_ dynamicDescriptor: String?) -> Bool {
        guard let dynamicDescriptor else { return true }
        return !dynamicDescriptor.isEmpty && dynamicDescriptor.count <= 20
    }

    /// Check if value is not empty and has no more than 13 characters.
    ///
    /// - Parameters:
    ///   - phone: Phone number
    static func isValidPhone(_ phone: String?) -> Bool {
        guard let phone else { return true }
        return !phone.isEmpty && phone.count <= 13
    }

    /// Check if value is not empty and has no more than 80 characters.
    ///
    /// - Parameters:
    ///   - firstName: First name
    static func isValidFirstName(_ firstName: String?) -> Bool {
        guard let firstName else { return true }
        return !firstName.isEmpty && firstName.count <= 80
    }

    /// Check if value is not empty and has no more than 80 characters.
    ///
    /// - Parameters:
    ///   - lastName: Last name
    static func isValidLastName(_ lastName: String?) -> Bool {
        guard let lastName else { return true }
        return !lastName.isEmpty && lastName.count <= 80
    }

    /// Check if value is not empty and has an email format.
    ///
    /// - Parameters:
    ///   - email: Email
    static func isValidEmail(_ email: String?) -> Bool {
        guard let email else { return true }
        return PSRegexValidator.evaluate(string: email, pattern: #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#)
    }
}
