//
//  PSCardValidatorTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import XCTest

final class PSCardValidatorTests: XCTestCase {
    func test_cardNumberLuhnCheck_validCard() {
        // Given
        let validCardNumber = "4111111111111111"

        // When
        let isValid = PSCardValidator.cardNumberLuhnCheck(validCardNumber)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_cardNumberLuhnCheck_invalidCard() {
        // Given
        let invalidCardNumber = "4111111111111192"

        // When
        let isValid = PSCardValidator.cardNumberLuhnCheck(invalidCardNumber)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_cardNumberLengthCheck_validLength() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("4111111111111111", .visa),
            ("6011000990139424", .discover),
            ("5105105105105100", .mastercard),
            ("378282246310005", .amex)
        ]

        cards.forEach { cardNumber, brand in
            // When
            let isValid = PSCardValidator.cardNumberLengthCheck(cardNumber, and: brand)

            // Then
            XCTAssertTrue(isValid)
        }
    }

    func test_cardNumberLengthCheck_invalidLength() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("411111111111111", .visa),
            ("601100099013942", .discover),
            ("510510510510510", .mastercard),
            ("3782822463100055", .amex)
        ]

        cards.forEach { cardNumber, brand in
            // When
            let isValid = PSCardValidator.validCardNumberCheck(cardNumber, and: brand)

            // Then
            XCTAssertFalse(isValid)
        }
    }

    func test_validCardNumberCheck_validCardNumbers() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("4111111111111111", .visa),
            ("6011000990139424", .discover),
            ("5105105105105100", .mastercard),
            ("378282246310005", .amex)
        ]

        cards.forEach { cardNumber, brand in
            // When
            let isValid = PSCardValidator.validCardNumberCheck(cardNumber, and: brand)

            // Then
            XCTAssertTrue(isValid)
        }
    }

    func test_validCardNumberCheck_invalidCardNumbers() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("411111111111111", .visa),
            ("601100099013942", .discover),
            ("510510510510510", .mastercard),
            ("3782822463100055", .amex)
        ]

        cards.forEach { cardNumber, brand in
            // When
            let isValid = PSCardValidator.validCardNumberCheck(cardNumber, and: brand)

            // Then
            XCTAssertFalse(isValid)
        }
    }

    func test_validCardNumberCharactersCheck_validCharacters() {
        // Given
        let validCharacters = "1234567890"

        // When
        let isValid = PSCardValidator.validCardNumberCharactersCheck(validCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validCardNumberCharactersCheck_invalidCharacters() {
        // Given
        let invalidCharacters = "abcd"

        // When
        let isValid = PSCardValidator.validCardNumberCharactersCheck(invalidCharacters)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validCardholderNameCheck_validCardholderName() {
        // Given
        let validCardholderName = "John Doe"

        // When
        let isValid = PSCardValidator.validCardholderNameCheck(validCardholderName)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validCardholderNameCheck_invalidCardholderName() {
        // Given
        let validCardholderName = "1234"

        // When
        let isValid = PSCardValidator.validCardholderNameCheck(validCardholderName)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validCardholderNameCharactersCheck_validCharacters() {
        // Given
        let validCharacters = "abcd"

        // When
        let isValid = PSCardValidator.validCardholderNameCharactersCheck(validCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validCardholderNameCharactersCheck_invalidCharacters() {
        // Given
        let invalidCharacters = "1234"

        // When
        let isValid = PSCardValidator.validCardholderNameCharactersCheck(invalidCharacters)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validExpiryDateCheck_validExpiryDate() {
        // Given
        let validCardholderName = "1223"

        // When
        let isValid = PSCardValidator.validExpiryDateCheck(validCardholderName)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validExpiryDateCheck_invalidExpiryDate() {
        // Given
        let validCardholderName = "12345"

        // When
        let isValid = PSCardValidator.validExpiryDateCheck(validCardholderName)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validExpiryDateCharactersCheck_validCharacters() {
        // Given
        let validCharacters = "1234"

        // When
        let isValid = PSCardValidator.validExpiryDateCharactersCheck(validCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validExpiryDateCharactersCheck_invalidCharacters() {
        // Given
        let invalidCharacters = "abcd"

        // When
        let isValid = PSCardValidator.validExpiryDateCharactersCheck(invalidCharacters)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_validCVVCheck_validCVV() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("123", .visa),
            ("123", .discover),
            ("123", .mastercard),
            ("1234", .amex),
            ("1234", .unknown)
        ]

        cards.forEach { cvv, brand in
            // When
            let isValid = PSCardValidator.validCVVCheck(cvv, and: brand)

            // Then
            XCTAssertTrue(isValid)
        }
    }

    func test_validCVVCheck_invalidCVV() {
        // Given
        let cards: [(String, PSCardBrand)] = [
            ("1234", .visa),
            ("1234", .discover),
            ("1234", .mastercard),
            ("123", .amex),
            ("12", .unknown)
        ]

        cards.forEach { cvv, brand in
            // When
            let isValid = PSCardValidator.validCVVCheck(cvv, and: brand)

            // Then
            XCTAssertFalse(isValid)
        }
    }

    func test_validCVVCharactersCheck_validCharacters() {
        // Given
        let validCharacters = "123"

        // When
        let isValid = PSCardValidator.validCVVCharactersCheck(validCharacters)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_validCVVCharactersCheck_invalidCharacters() {
        // Given
        let invalidCharacters = "abc"

        // When
        let isValid = PSCardValidator.validCVVCharactersCheck(invalidCharacters)

        // Then
        XCTAssertFalse(isValid)
    }
}
