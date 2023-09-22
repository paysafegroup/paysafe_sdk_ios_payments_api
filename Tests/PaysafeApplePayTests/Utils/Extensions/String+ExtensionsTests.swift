//
//  String+ExtensionsTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeApplePay
import XCTest

class StringExtensionTests: XCTestCase {
    func test_nilIfEmpty_ReturnsNilForEmptyString() {
        // Given
        let emptyString = ""

        // When
        let result = emptyString.nilIfEmpty

        // Then
        XCTAssertNil(result, "Expected nil for an empty string, but got something else.")
    }

    func test_nilIfEmpty_ReturnsOriginalStringForNonEmptyString() {
        // Given
        let nonEmptyString = "Paysafe"

        // When
        let result = nonEmptyString.nilIfEmpty

        // Then
        XCTAssertNotNil(result, "Expected the original string for a non-empty string, but got nil.")
        XCTAssertEqual(result, nonEmptyString, "Expected the original string, but the result was different.")
    }
}
