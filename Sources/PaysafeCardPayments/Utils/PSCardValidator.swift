//
//  PSCardValidator.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

enum PSCardValidator {
    /// Verifies card number using the Luhn algorithm
    /// - Parameters:
    ///   - number: Credit card number
    static func cardNumberLuhnCheck(_ number: String) -> Bool {
        let digits = number.reversed().compactMap { Int(String($0)) }
        var sum = 0
        digits.enumerated().forEach { index, digit in
            let isOdd = !index.isMultiple(of: 2)
            switch (isOdd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        return sum.isMultiple(of: 10)
    }

    /// Verifies card number length
    /// - Parameters:
    ///   - number: Credit card number
    ///   - brand: Credit card brand
    static func cardNumberLengthCheck(_ number: String, and brand: PSCardBrand) -> Bool {
        number.count == brand.cardNumberLength
    }

    // MARK: - Card number

    /// Verifies card number using regex pattern
    /// - Parameters:
    ///   - number: Credit card number
    ///   - brand: Credit card brand
    static func validCardNumberCheck(_ number: String, and brand: PSCardBrand) -> Bool {
        PSRegexValidator.evaluate(string: number, pattern: "[0-9]{\(brand.cardNumberLength)}")
    }

    /// Verifies card number characters using regex pattern
    /// - Parameters:
    ///   - characters: Credit card number characters
    static func validCardNumberCharactersCheck(_ characters: String) -> Bool {
        PSRegexValidator.evaluate(string: characters, pattern: .onlyDigitsRegexPattern)
    }

    // MARK: - Cardholder name

    /// Verifies cardholder name using regex pattern
    /// - Parameters:
    ///   - cardholderName: Credit cardholder name
    static func validCardholderNameCheck(_ cardholderName: String) -> Bool {
        PSRegexValidator.evaluate(string: cardholderName, pattern: "[A-Za-zÀ-ÿ' -]{2,}")
    }

    /// Verifies cardholder name characters using regex pattern
    /// - Parameters:
    ///   - characters: Credit cardholder name characters
    static func validCardholderNameCharactersCheck(_ characters: String) -> Bool {
        PSRegexValidator.evaluate(string: characters, pattern: "[A-Za-zÀ-ÿ' -]+")
    }

    // MARK: - Expiry date

    /// Verifies card expiry date using regex pattern
    /// - Parameters:
    ///   - expiryDate: Credit card expiry date
    static func validExpiryDateCheck(_ expiryDate: String) -> Bool {
        PSRegexValidator.evaluate(string: expiryDate, pattern: "[0-9]{4}")
    }

    /// Verifies card expiry date characters using regex pattern
    /// - Parameters:
    ///   - characters: Credit card expiry date characters
    static func validExpiryDateCharactersCheck(_ characters: String) -> Bool {
        PSRegexValidator.evaluate(string: characters, pattern: .onlyDigitsRegexPattern)
    }

    // MARK: - CVV

    /// Verifies card CVV using regex pattern
    /// - Parameters:
    ///   - cvv: Credit card CVV
    ///   - brand: Credit card brand
    static func validCVVCheck(_ cvv: String, and brand: PSCardBrand) -> Bool {
        switch brand {
        case .visa, .mastercard, .discover:
            return PSRegexValidator.evaluate(string: cvv, pattern: "[0-9]{3}")
        case .amex:
            return PSRegexValidator.evaluate(string: cvv, pattern: "[0-9]{4}")
        case .unknown:
            return PSRegexValidator.evaluate(string: cvv, pattern: "[0-9]{3,4}")
        }
    }

    /// Verifies card CVV characters using regex pattern
    /// - Parameters:
    ///   - characters: Credit card CVV characters
    static func validCVVCharactersCheck(_ characters: String) -> Bool {
        PSRegexValidator.evaluate(string: characters, pattern: .onlyDigitsRegexPattern)
    }
}

// MARK: - Regex patterns
extension String {
    /// Only digits regex pattern
    static let onlyDigitsRegexPattern = "[0-9]+"
}
