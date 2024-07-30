//
//  APIErrorTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon
import XCTest

final class APIErrorTests: XCTestCase {
    func test_coreInvalidCurrencyCode() {
        let expectedCode = 9055
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "5001", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_coreInvalidAPIKeyFormat() {
        let expectedCode = 9013
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "5279", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_encodingError() {
        let expectedCode = 9205
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "9205", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_invalidURL() {
        let expectedCode = 9168
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "9168", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_timeoutError() {
        let expectedCode = 9204
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "9204", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_noConnectionToServer() {
        let expectedCode = 9001
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "9001", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_genericAPIError() {
        let expectedCode = 9014
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "9014", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_invalidResponse() {
        let expectedCode = 9002
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "9002", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
    
    func test_default() {
        let expectedCode = 1111
        // Given
        let apiError = APIError.init(error: ErrorDetails(code: "1111", message: ""))
        
        // When
        let psError = apiError.toPSError("")
        
        // Then
        XCTAssertEqual(psError.code, expectedCode)
    }
}
