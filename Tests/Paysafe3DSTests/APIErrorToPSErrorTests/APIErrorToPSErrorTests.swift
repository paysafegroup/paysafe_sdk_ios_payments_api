//
//  APIErrorToPSErrorTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import Paysafe3DS
@testable import PaysafeCommon

import XCTest

final class APIErrorToPSErrorTests: XCTestCase {
    
    func test_with5000ErrorCode_returnsInvalidAPIKey() {
        // Given
        let errorCode = "5000"
        let detailedMessage = "Invalid apiKey parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9013
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidApiKey, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5275ErrorCode_returnsInvalidAPIKey() {
        // Given
        let errorCode = "5275"
        let detailedMessage = "Invalid apiKey parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9013
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidApiKey, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5276ErrorCode_returnsInvalidAPIKey() {
        // Given
        let errorCode = "5276"
        let detailedMessage = "Invalid apiKey parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9013
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidApiKey, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5278ErrorCode_returnsInvalidAPIKey() {
        // Given
        let errorCode = "5278"
        let detailedMessage = "Invalid apiKey parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9013
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidApiKey, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5280ErrorCode_returnsInvalidAPIKey() {
        // Given
        let errorCode = "5280"
        let detailedMessage = "Invalid apiKey parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9013
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidApiKey, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5010ErrorCode_returnsThreeDSInvalidCountryParameter() {
        // Given
        let errorCode = "5010"
        let detailedMessage = "Invalid country parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9068
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidCountry, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5003ErrorCode_returnsInvalidAmount() {
        // Given
        let errorCode = "5003"
        let detailedMessage = "Amount should be a number greater than 0 no longer than 11 characters."
        let correlationId = "test-correlation-id"
        let expectedCode = 9054
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidAmount, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5001ErrorCode_returnsThreeDSInvalidAPIKey() {
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
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidCurrency, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
    
    func test_with5279ErrorCode_returnsInvalidAPIKey() {
        // Given
        let errorCode = "5279"
        let detailedMessage = "Invalid apiKey parameter."
        let correlationId = "test-correlation-id"
        let expectedCode = 9013
        let apiError = APIError(error: ErrorDetails(
            code: errorCode,
            message: detailedMessage
        ))

        // When
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidApiKey, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
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
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSEncodingError, "The errorCode does not match the expected value.")
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
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .threeDSInvalidURL, "The errorCode does not match the expected value.")
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
        let resultError = apiError.from3DStoPSError(correlationId)

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
        let resultError = apiError.from3DStoPSError(correlationId)

        // Then
        XCTAssertEqual(resultError.errorCode, .noConnectionToServer, "The errorCode does not match the expected value.")
        XCTAssertEqual(resultError.correlationId, correlationId, "The correlationId does not match.")
        XCTAssertEqual(resultError.code, expectedCode, "The code does not match the expected value.")
        XCTAssertEqual(resultError.detailedMessage, detailedMessage, "The detailedMessage does not match.")
    }
}
