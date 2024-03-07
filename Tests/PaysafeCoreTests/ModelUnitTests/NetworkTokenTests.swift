//
//  NetworkTokenTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

class NetworkTokenTests: XCTestCase {
    func test_NetworkToken_Decoding() throws {
        // Given
        let jsonData = """
        {
            "bin": "483934"
        }
        """.data(using: .utf8)!

        // When
        let decoder = JSONDecoder()
        let networkToken = try decoder.decode(NetworkToken.self, from: jsonData)

        // Then
        XCTAssertNotNil(networkToken, "The NetworkToken should be successfully decoded.")
        XCTAssertEqual(networkToken.bin, "483934", "The bin property should correctly decode from JSON.")
    }

    func test_NetworkToken_DecodingFailsWithInvalidJSON() throws {
        // Given an invalid JSON format for a NetworkToken
        let jsonData = """
        {
            "invalidKey": "someValue"
        }
        """.data(using: .utf8)!

        // When / Then
        XCTAssertThrowsError(try JSONDecoder().decode(NetworkToken.self, from: jsonData)) { error in
            guard case .keyNotFound = (error as? DecodingError) else {
                return XCTFail("Expected '.keyNotFound' error but got \(error)")
            }
        }
    }
}
