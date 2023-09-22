//
//  PSCardUtils.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

enum PSCardUtils {
    /// Determines the Card brand based on the card number
    ///
    /// - Parameters:
    ///   - number: The card number
    static func determineCardBrand(_ number: String) -> PSCardBrand {
        switch true {
        case PSRegexValidator.evaluate(string: number, pattern: PSCardBrand.visa.cardValidationPattern):
            return .visa
        case PSRegexValidator.evaluate(string: number, pattern: PSCardBrand.amex.cardValidationPattern):
            return .amex
        case PSRegexValidator.evaluate(string: number, pattern: PSCardBrand.mastercard.cardValidationPattern):
            return .mastercard
        case PSRegexValidator.evaluate(string: number, pattern: PSCardBrand.discover.cardValidationPattern):
            return .discover
        default:
            return .unknown
        }
    }

    /// Validates the card number
    ///
    /// - Parameters:
    ///   - number: The card number
    static func validateCardNumber(_ number: String) -> Bool {
        let cardBrand = PSCardUtils.determineCardBrand(number)
        let cardBrandCheck = cardBrand.isValid
        let cardLengthCheck = PSCardValidator.cardNumberLengthCheck(number, and: cardBrand)
        let regexCheck = PSCardValidator.validCardNumberCheck(number, and: cardBrand)
        let luhnCheck = PSCardValidator.cardNumberLuhnCheck(number)
        return cardBrandCheck && cardLengthCheck && regexCheck && luhnCheck
    }

    /// Validates the card number characters
    ///
    /// - Parameters:
    ///   - characters: Card number characters
    static func validateCardNumberCharacters(_ characters: String) -> Bool {
        guard !characters.isEmpty else { return true }
        return PSCardValidator.validCardNumberCharactersCheck(characters)
    }

    /// Determines card number format based on card brand
    ///
    /// - Parameters:
    ///   - number: The card number
    static func cardNumberFormat(_ number: String) -> [Int] {
        determineCardBrand(number).cardNumberFormat
    }

    /// Validates the card expiration date
    ///
    /// - Parameters:
    ///   - date: The card expiration date
    static func validateExpiryDate(_ date: String) -> Bool {
        let strippedDate = PSCardUtils.stripNonDigitCharacters(from: date)
        let regexCheck = PSCardValidator.validExpiryDateCheck(strippedDate)
        guard regexCheck,
              let month = Int(strippedDate.prefix(2)),
              let year = Int(strippedDate.suffix(2)) else { return false }
        return validateYear(year) && validateMonth(month: month, year: year)
    }

    /// Validates the card expiration date characters
    ///
    /// - Parameters:
    ///   - characters: Card expiry date characters
    ///   - potentialDate: Potential card expiry date
    static func validateExpiryDateCharacters(_ characters: String) -> Bool {
        guard !characters.isEmpty else { return true }
        return PSCardValidator.validExpiryDateCharactersCheck(characters)
    }

    /// Validates the card expiration year
    ///
    /// - Parameters:
    ///   - year: The card expiration year
    static func validateYear(_ year: Int) -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        return (currentYear...currentYear + 20).contains(year)
    }

    /// Validates the card expiration month
    ///
    /// - Parameters:
    ///   - month: The card expiration month
    ///   - year: The card expiration year
    static func validateMonth(month: Int, year: Int) -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())
        return (1...12).contains(month) && (currentYear == year ? month >= currentMonth : true)
    }

    /// Determines the full expiry year from suffix (e.g. 23)
    ///
    /// - Parameters:
    ///   - year: Expiration year suffix
    static func determineFullExpiryYear(from year: Int) -> Int {
        Calendar.current.component(.year, from: Date()) / 100 * 100 + year
    }

    /// Strips string of non-digit characters
    ///
    /// - Parameters:
    ///   - date: The card expiration date
    static func stripNonDigitCharacters(from date: String) -> String {
        date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
}
