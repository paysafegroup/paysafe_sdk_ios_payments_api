//
//  APIErrorTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeNetworking
import XCTest

final class PSErrorTests: XCTestCase {
    
    func test_APIError_creation() throws {
        // Given
        let json = APIError.jsonMock(
            code: "404",
            message: "Error communicating with server."
        ).data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let apiError = try decoder.decode(APIError.self, from: json)
        
        // Then
        XCTAssertEqual(apiError.error.code, "404", "Error code should be correctly decoded")
        XCTAssertEqual(apiError.error.message, "Error communicating with server.", "Error message should be correctly decoded")
    }
    
    func test_encodingError_properties() {
        // Given
        let encodingError = APIError.encodingError
        
        // Then
        XCTAssertEqual(encodingError.error.code, "9205", "EncodingError code should match predefined value")
        XCTAssertEqual(encodingError.error.message, "Encoding error.", "EncodingError message should match predefined value")
    }
    
    func test_invalidURL_properties() {
        // Given
        let encodingError = APIError.invalidURL
        
        // Then
        XCTAssertEqual(encodingError.error.code, "9168", "EncodingError code should match predefined value")
        XCTAssertEqual(encodingError.error.message, "Error communicating with server.", "EncodingError message should match predefined value")
    }
    
    func test_timeoutError_properties() {
        // Given
        let encodingError = APIError.timeoutError
        
        // Then
        XCTAssertEqual(encodingError.error.code, "9204", "EncodingError code should match predefined value")
        XCTAssertEqual(encodingError.error.message, "Timeout error.", "EncodingError message should match predefined value")
    }
    
    func test_noConnectionToServer_properties() {
        // Given
        let encodingError = APIError.noConnectionToServer
        
        // Then
        XCTAssertEqual(encodingError.error.code, "9001", "EncodingError code should match predefined value")
        XCTAssertEqual(encodingError.error.message, "No connection to server.", "EncodingError message should match predefined value")
    }
    
    func test_genericAPIError_properties() {
        // Given
        let encodingError = APIError.genericAPIError
        
        // Then
        XCTAssertEqual(encodingError.error.code, "9014", "EncodingError code should match predefined value")
        XCTAssertEqual(encodingError.error.message, "Unhandled error occurred.", "EncodingError message should match predefined value")
    }
    
    func test_invalidResponse_properties() {
        // Given
        let encodingError = APIError.invalidResponse
        
        // Then
        XCTAssertEqual(encodingError.error.code, "9002", "EncodingError code should match predefined value")
        XCTAssertEqual(encodingError.error.message, "Error communicating with server.", "EncodingError message should match predefined value")
    }
}
