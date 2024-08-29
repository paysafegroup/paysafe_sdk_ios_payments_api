//
//  PSTokenizeOptionsUtils.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import XCTest

final class PSTokenizeOptionsUtilsTests: XCTestCase {
    func test_isValidAmount_valid() {
        // Given
        let amount: Int = 100

        // When
        let isValid = PSTokenizeOptionsUtils.isValidAmount(amount)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_isValidAmount_tooLow() {
        // Given
        let amount: Int = 0

        // When
        let isValid = PSTokenizeOptionsUtils.isValidAmount(amount)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_isValidAmount_tooHigh() {
        // Given
        let amount: Int = 1_000_000_000

        // When
        let isValid = PSTokenizeOptionsUtils.isValidAmount(amount)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_isValidDynamicDescriptor_valid() {
        // Given
        let dynamicDescriptor = String(repeating: "a", count: 10)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidDynamicDescriptor(dynamicDescriptor)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_isValidDynamicDescriptor_tooLong() {
        // Given
        let dynamicDescriptor = String(repeating: "a", count: 21)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidDynamicDescriptor(dynamicDescriptor)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_isValidPhone_valid() {
        // Given
        let phone = String(repeating: "0", count: 10)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidPhone(phone)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_isValidPhone_tooLong() {
        // Given
        let phone = String(repeating: "0", count: 14)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidPhone(phone)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_isValidFirstName_valid() {
        // Given
        let firstName = String(repeating: "a", count: 10)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidFirstName(firstName)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_isValidFirstName_tooLong() {
        // Given
        let firstName = String(repeating: "a", count: 81)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidFirstName(firstName)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_isValidLastName_valid() {
        // Given
        let lastName = String(repeating: "a", count: 10)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidLastName(lastName)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_isValidLastName_tooLong() {
        // Given
        let lastName = String(repeating: "a", count: 81)

        // When
        let isValid = PSTokenizeOptionsUtils.isValidLastName(lastName)

        // Then
        XCTAssertFalse(isValid)
    }

    func test_isValidEmail_valid() {
        // Given
        let email = "test@paysafe.com"

        // When
        let isValid = PSTokenizeOptionsUtils.isValidEmail(email)

        // Then
        XCTAssertTrue(isValid)
    }

    func test_isValidEmail_invalid() {
        // Given
        let email = "test@paysafe"

        // When
        let isValid = PSTokenizeOptionsUtils.isValidEmail(email)

        // Then
        XCTAssertFalse(isValid)
    }
}
