//
//  IdentityDocumentRequestTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

class IdentityDocumentRequestTests: XCTestCase {
    func test_identityDocument_RequestEncoding() throws {
        // Given
        let documentNumber = "123456789"
        let request = IdentityDocumentRequest(documentNumber: documentNumber)

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

        // Then
        XCTAssertEqual(dictionary?["type"] as? String, "SOCIAL_SECURITY")
        XCTAssertEqual(dictionary?["documentNumber"] as? String, documentNumber)
    }
}
