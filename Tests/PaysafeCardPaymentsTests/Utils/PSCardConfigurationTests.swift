//
//  PSCardConfigurationTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import XCTest

final class PSCardConfigurationTests: XCTestCase {
    func test_makeCardNumberDisplayText_fullDefaultCardNumnber() {
        // Given
        let cardNumber = "4000000000001091"
        let separator = " "

        // Then
        let attributedText = PSCardConfiguration.makeCardNumberDisplayText(for: cardNumber, with: separator)

        // When
        XCTAssertEqual(attributedText.string, "4000 0000 0000 1091")
    }

    func test_makeCardNumberDisplayText_partialDefaultCardNumnber() {
        // Given
        let cardNumber = "40000000"
        let separator = " "

        // Then
        let attributedText = PSCardConfiguration.makeCardNumberDisplayText(for: cardNumber, with: separator)

        // When
        XCTAssertEqual(attributedText.string, "4000 0000")
    }

    func test_makeCardNumberDisplayText_fullAmexCardNumnber() {
        // Given
        let cardNumber = "378282246310005"
        let separator = " "

        // Then
        let attributedText = PSCardConfiguration.makeCardNumberDisplayText(for: cardNumber, with: separator)

        // When
        XCTAssertEqual(attributedText.string, "3782 822463 10005")
    }

    func test_makeCardNumberDisplayText_partialAmexCardNumnber() {
        // Given
        let cardNumber = "3782822463"
        let separator = " "

        // Then
        let attributedText = PSCardConfiguration.makeCardNumberDisplayText(for: cardNumber, with: separator)

        // When
        XCTAssertEqual(attributedText.string, "3782 822463")
    }

    func test_makeCardNumberDisplayText_nilInput() {
        // Given
        let cardNumber: String? = nil
        let separator = " "

        // Then
        let attributedText = PSCardConfiguration.makeCardNumberDisplayText(for: cardNumber, with: separator)

        // When
        XCTAssertTrue(attributedText.string.isEmpty)
    }

    func test_makeCardExpiryDateDisplayText_oneDigit() {
        // Given
        let expiryDate = "1"

        // When
        let attributedText = PSCardConfiguration.makeCardExpiryDateDisplayText(for: expiryDate)

        // Then
        XCTAssertEqual(attributedText.string, "1")
    }

    func test_makeCardExpiryDateDisplayText_oneDigitAddsZeroPrefix() {
        // Given
        let expiryDate = "2"

        // When
        let attributedText = PSCardConfiguration.makeCardExpiryDateDisplayText(for: expiryDate)

        // Then
        XCTAssertEqual(attributedText.string, "02")
    }

    func test_makeCardExpiryDateDisplayText_twoDigits() {
        // Given
        let expiryDate = "12"

        // When
        let attributedText = PSCardConfiguration.makeCardExpiryDateDisplayText(for: expiryDate)

        // Then
        XCTAssertEqual(attributedText.string, "12")
    }

    func test_makeCardExpiryDateDisplayText_threeDigits() {
        // Given
        let expiryDate = "122"

        // When
        let attributedText = PSCardConfiguration.makeCardExpiryDateDisplayText(for: expiryDate)

        // Then
        XCTAssertEqual(attributedText.string, "12 / 2")
    }

    func test_makeCardExpiryDateDisplayText_fourDigits() {
        // Given
        let expiryDate = "1223"

        // When
        let attributedText = PSCardConfiguration.makeCardExpiryDateDisplayText(for: expiryDate)

        // Then
        XCTAssertEqual(attributedText.string, "12 / 23")
    }

    func test_makeCardExpiryDateDisplayText_nilInput() {
        // Given
        let expiryDate: String? = nil

        // When
        let attributedText = PSCardConfiguration.makeCardExpiryDateDisplayText(for: expiryDate)

        // Then
        XCTAssertTrue(attributedText.string.isEmpty)
    }
}
