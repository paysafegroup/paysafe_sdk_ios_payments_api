//
//  APIErrorToPSErrorTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
@testable import PaysafeCommon

import XCTest

final class APIErrorToPSErrorTests: XCTestCase {
    func test_with5001ErrorCode_returnsInvalidCurrency() {
        // Given
        let errorCode = "5001"
        let detailedMessage = "Invalid currency parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9055
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.toPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .coreInvalidCurrencyCode, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "Invalid currency parameter.")
    }

    func test_with9205ErrorCode_returnsEncodingError() {
        // Given
        let errorCode = "9205"
        let detailedMessage = "Encoding error."
        let correlationId = "test-correlation-id"
        let expectedCode = 9205
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.toPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .encodingError, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }

    func test_with9168ErrorCode_returnsInvalidURL() {
        // Given
        let errorCode = "9168"
        let detailedMessage = "Error communicating with server."
        let correlationId = "test-correlation-id"
        let expectedCode = 9168
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.toPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .invalidURL, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }

    func test_with9204ErrorCode_returnsTimeoutError() {
        // Given
        let errorCode = "9204"
        let detailedMessage = "Timeout error."
        let correlationId = "test-correlation-id"
        let expectedCode = 9204
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.toPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .timeoutError, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }

    func test_with9001ErrorCode_returnsNoConnectionToServer() {
        // Given
        let errorCode = "9001"
        let detailedMessage = "No connection to server."
        let correlationId = "test-correlation-id"
        let expectedCode = 9001
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.toPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .noConnectionToServer, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
}
