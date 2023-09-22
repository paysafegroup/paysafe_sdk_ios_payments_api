//
//  BillingCycleRequestTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

class BillingCycleRequestTests: XCTestCase {
    func test_billingCycleRequest_Encoding() throws {
        // Given
        let endDate = "2024-12-31"
        let frequency = 12

        let billingCycle = BillingCycleRequest(
            endDate: endDate,
            frequency: frequency
        )

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(billingCycle)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")

        XCTAssertEqual(json?["endDate"] as? String, endDate, "endDate should be correctly encoded")
        XCTAssertEqual(json?["frequency"] as? Int, frequency, "frequency should be correctly encoded")
    }

    func test_billingCycleRequest_EncodingWithNilValues() throws {
        // Given
        let billingCycle = BillingCycleRequest(endDate: nil, frequency: nil)

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(billingCycle)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")

        XCTAssertNil(json?["endDate"], "endDate should not be encoded when nil")
        XCTAssertNil(json?["frequency"], "frequency should not be encoded when nil")
    }
}
