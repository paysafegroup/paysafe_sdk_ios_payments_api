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
        var request = IdentityDocumentRequest(documentNumber: documentNumber)
        request.type = "SOCIAL"

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

// Then
#if DEBUG
        XCTAssertEqual(request.type, "SOCIAL")
#endif
        XCTAssertEqual(dictionary?["type"] as? String, "SOCIAL")
        XCTAssertEqual(dictionary?["documentNumber"] as? String, documentNumber)
    }
}
