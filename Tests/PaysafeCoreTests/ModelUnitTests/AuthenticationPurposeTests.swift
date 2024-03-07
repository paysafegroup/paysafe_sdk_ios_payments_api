//
//  AuthenticationPurposeTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

class AuthenticationPurposeTests: XCTestCase {
    func test_authenticationPurpose_Encoding() throws {
        let allCases = AuthenticationPurpose.allCases
        let encoder = JSONEncoder()

        try allCases.forEach { authPurpose in
            // When
            let data = try encoder.encode(authPurpose)
            let jsonString = String(data: data, encoding: .utf8)

            // Then
            let expectedJsonString = "\"\(authPurpose.rawValue)\""
            XCTAssertEqual(jsonString, expectedJsonString, "Encoded JSON does not match expected format for \(authPurpose).")
        }
    }

    func test_authenticationPurpose_Request() {
        AuthenticationPurpose.allCases.forEach { authPurpose in
            // When
            let request = authPurpose.request

            // Then
            switch authPurpose {
            case .paymentTransaction:
                XCTAssertEqual(request, AuthenticationPurposeRequest.paymentTransaction)
            case .instalmentTransaction:
                XCTAssertEqual(request, AuthenticationPurposeRequest.instalmentTransaction)
            case .recurringTransaction:
                XCTAssertEqual(request, AuthenticationPurposeRequest.recurringTransaction)
            case .addCard:
                XCTAssertEqual(request, AuthenticationPurposeRequest.addCard)
            case .maintainCard:
                XCTAssertEqual(request, AuthenticationPurposeRequest.maintainCard)
            case .emvTokenVerification:
                XCTAssertEqual(request, AuthenticationPurposeRequest.emvTokenVerification)
            }
        }
    }
}
