//
//  CardRequestTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon
import XCTest

final class CardRequestTests: XCTestCase {
    func test_cardRequest_Encoding() throws {
        // Given
        let card = CardRequest(cvv: "123", holderName: "Jane Doe")

        // When
        let data = try JSONEncoder().encode(card)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")
        XCTAssertEqual(json?["cvv"] as? String, "123")
        XCTAssertEqual(json?["holderName"] as? String, "Jane Doe")
    }

    func test_cardRequest_EncodingWithNilCvv() throws {
        // Given
        let card = CardRequest(holderName: "Jane Doe")

        // When
        let data = try JSONEncoder().encode(card)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")
        XCTAssertNil(json?["cvv"], "cvv should not be encoded when nil")
        XCTAssertEqual(json?["holderName"] as? String, "Jane Doe")
    }
}
