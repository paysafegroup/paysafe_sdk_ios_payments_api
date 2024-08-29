//
//  PSCardUtilsTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import XCTest

final class PSCardUtilsTests: XCTestCase {
    func test_determineCardBrand() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("4111111111111111", .visa),
            ("6011000990139424", .discover),
            ("5105105105105100", .mastercard),
            ("378282246310005", .amex),
            ("1241242141242142", .unknown)
        ]

        // Then
        cards.forEach { cardNumber, expectedCardBrand in
            // When
            let cardBrand = PSCardUtils.determineCardBrand(cardNumber)

            // Then
            XCTAssertEqual(cardBrand, expectedCardBrand)
        }
    }

    func test_validateCardNumber_validCardNumber() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("4111111111111111", .visa),
            ("6011000990139424", .discover),
            ("5105105105105100", .mastercard),
            ("378282246310005", .amex)
        ]

        // Then
        cards.forEach { cardNumber, _ in
            // When
            let isValid = PSCardUtils.validateCardNumber(cardNumber)

            // Then
            XCTAssertTrue(isValid)
        }
    }

    func test_validateCardNumber_invalidCardNumber() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("4111111111111112", .visa),
            ("6011000990139425", .discover),
            ("5105105105105101", .mastercard),
            ("378282246310006", .amex)
        ]

        // Then
        cards.forEach { cardNumber, _ in
            // When
            let isValid = PSCardUtils.validateCardNumber(cardNumber)

            // Then
            XCTAssertFalse(isValid)
        }
    }

    func test_validateCardNumberCharacters_validCharacters() {
        // Given
        let validCharacters = "1111"

        // When
        let isValid = PSCardUtils.validateCardNumberCharacters(validCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validateCardNumberCharacters_invalidCharacters() {
        // Given
        let invalidCharacters = "abcd"

        // When
        let isValid = PSCardUtils.validateCardNumberCharacters(invalidCharacters)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validateCardNumberCharacters_emptyCharacters() {
        // Given
        let emptyCharacters = ""

        // When
        let isValid = PSCardUtils.validateCardNumberCharacters(emptyCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_cardNumberFormat() {
        // Given
        let cards: [(String, [Int])] = [
            ("4111111111111111", [4, 4, 4, 4]),
            ("6011000990139424", [4, 4, 4, 4]),
            ("5105105105105100", [4, 4, 4, 4]),
            ("378282246310005", [4, 6, 5])
        ]

        // Then
        cards.forEach { cardNumber, expectedCardNumberFormat in
            // When
            let cardNumberFormat = PSCardUtils.cardNumberFormat(cardNumber)

            // Then
            XCTAssertEqual(cardNumberFormat, expectedCardNumberFormat)
        }
    }

    func test_validateExpiryDate_valid() {
        // Given
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let validMonth = String(format: "%02d", currentMonth)
        let validYear = String(currentYear).suffix(2)
        let validDate = "\(validMonth) / \(validYear)"

        // When
        let isValid = PSCardUtils.validateExpiryDate(validDate)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validateExpiryDate_expired() {
        // Given
        let currentMonth = Calendar.current.component(.month, from: Date())
        let previousYear = Calendar.current.component(.year, from: Date()) % 100 - 1
        let validMonth = String(format: "%02d", currentMonth)
        let expiredYear = String(previousYear)
        let expiredDate = "\(validMonth) / \(expiredYear)"

        // When
        let isValid = PSCardUtils.validateExpiryDate(expiredDate)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validateExpiryDate_invalidDate() {
        // Given
        let invalidFormatDate = "13/23"

        // When
        let isValid = PSCardUtils.validateExpiryDate(invalidFormatDate)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validateExpiryDate_invalidCharacters() {
        // Given
        let invalidFormatDate = "13/ab"

        // When
        let isValid = PSCardUtils.validateExpiryDate(invalidFormatDate)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validateExpiryDateCharacters_validCharacters() {
        // Given
        let validCharacters = "12"

        // When
        let isValid = PSCardUtils.validateExpiryDateCharacters(validCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validateExpiryDateCharacters_invalidCharacters() {
        // Given
        let invalidCharacters = "ab"

        // When
        let isValid = PSCardUtils.validateExpiryDateCharacters(invalidCharacters)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validateExpiryDateCharacters_emptyCharacters() {
        // Given
        let emptyCharacters = ""

        // When
        let isValid = PSCardUtils.validateExpiryDateCharacters(emptyCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validateYear_validYear() {
        // Given
        let validYear = Calendar.current.component(.year, from: Date()) % 100

        // When
        let isValid = PSCardUtils.validateYear(validYear)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validateYear_invalidYear() {
        // Given
        let invalidYear = Calendar.current.component(.year, from: Date()) % 100 - 1

        // When
        let isValid = PSCardUtils.validateYear(invalidYear)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validateMonth_validMonthCurrentYear() {
        // Given
        let validMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date()) % 100

        // When
        let isValid = PSCardUtils.validateMonth(month: validMonth, year: currentYear)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validateMonth_validMonthFutureYear() {
        // Given
        let validMonth = 6
        let futureYear = Calendar.current.component(.year, from: Date()) % 100 + 1

        // When
        let isValid = PSCardUtils.validateMonth(month: validMonth, year: futureYear)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validateMonth_invalidMonth() {
        // Given
        let invalidMonth = 13
        let currentYear = Calendar.current.component(.year, from: Date()) % 100

        // When
        let isValid = PSCardUtils.validateMonth(month: invalidMonth, year: currentYear)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_determineFullExpiryYear() {
        // Given
        let currentYear = Calendar.current.component(.year, from: Date())
        let suffixYear = currentYear % 100

        // When
        let fullYear = PSCardUtils.determineFullExpiryYear(from: suffixYear)

        // Then
        XCTAssertEqual(fullYear, currentYear)
    }

    func test_stripDateString_onlyDigitCharacters() {
        // Given
        let strippedDateString = "0123"

        // When
        let strippedDate = PSCardUtils.stripNonDigitCharacters(from: strippedDateString)

        // Then
        XCTAssertEqual(strippedDate, strippedDateString)
    }

    func test_stripDateString_withNonDigitCharacters() {
        // Given
        let displayDateString = "12 / 23"

        // When
        let strippedDate = PSCardUtils.stripNonDigitCharacters(from: displayDateString)

        // Then
        XCTAssertEqual(strippedDate, "1223")
    }

    func test_stripDateString_emptyString() {
        // Given
        let emptyString = ""

        // When
        let strippedDate = PSCardUtils.stripNonDigitCharacters(from: emptyString)

        // Then
        XCTAssertEqual(strippedDate, emptyString)
    }
}
