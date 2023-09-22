//
//  RecipientTypeTests.swift
//
//
//  Created by Joseph on 09.02.2024.
//

@testable import PaysafeCore
import XCTest

class RecipientTypeTests: XCTestCase {
    func test_recipientType_Encoding() throws {
        // Given
        let recipientType = RecipientType.payPalId

        // When
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(recipientType)
        let jsonString = String(data: data, encoding: .utf8)

        // Then
        let expectedJsonString = "{\"payPalId\":{}}"
        XCTAssertEqual(jsonString, expectedJsonString, "Encoded JSON does not match expected format.")
    }

    func test_recipientType_Request() {
        // Given
        let recipientType = RecipientType.payPalId

        // When
        let request = recipientType.request

        // Then
        XCTAssertEqual(request, RecipientTypeRequest.payPalId)
    }
}
