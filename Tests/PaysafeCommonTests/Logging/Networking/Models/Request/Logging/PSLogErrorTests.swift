//
//  PSLogErrorTests.swift
//
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCommon

final class PSLogErrorTests: XCTestCase {
    func test_toLogError() {
        // Given
        let code = 30
        let detailedMessage = "Test Message"
        let error = PSError(errorCode: .applePayNotSupported, correlationId: "correlationId", code: code, detailedMessage: detailedMessage)
        
        // When
        let logError = error.toLogError()
        
        // Then
        XCTAssertEqual(logError.code, code)
        XCTAssertEqual(logError.detailedMessage, detailedMessage)
        XCTAssertNotNil(logError.displayMessage)
    }
}
