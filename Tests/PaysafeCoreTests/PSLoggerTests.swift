//
//  PSLoggerTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
@testable import PaysafeCore
import PaysafeNetworking
import XCTest

final class PSLoggerTests: XCTestCase {
    var sut: PSLogger!
    var mockSession: URLSessionMock!
    var mockNetworkingService: PSNetworkingService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockSession = URLSessionMock()
        mockNetworkingService = PSNetworkingService(
            session: mockSession,
            authorizationKey: "apiKey",
            correlationId: "correlationId",
            sdkVersion: "1.0.0"
        )
        sut = PSLogger(
            apiKey: "am9objpkb2UK",
            correlationId: "correlationId",
            baseURL: "https://test.ps.com",
            integrationType: .paymentsApi
        )
        sut.networkingService = mockNetworkingService
        cancellables = []
    }

    override func tearDown() {
        mockSession = nil
        mockNetworkingService = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_mobileLog_Conversion() throws {
        // Given
        let message = "Conversion message test"
        let expectedURL = try XCTUnwrap(URL(string: "https://test.ps.com/mobile/api/v1/log"))
        mockSession.stubRequest(url: expectedURL, data: nil, response: nil, error: nil)

        // When
        sut.log(eventType: .conversion, message: message)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, expectedURL)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
    }

    func test_mobileLog_warn() throws {
        // Given
        let message = "Warn message test"
        let expectedURL = try XCTUnwrap(URL(string: "https://test.ps.com/mobile/api/v1/log"))
        mockSession.stubRequest(url: expectedURL, data: nil, response: nil, error: nil)

        // When
        sut.log(eventType: .warn, message: message)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, expectedURL)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
    }

    func test_mobileLog_genericError() throws {
        // Given
        let message = "Generic error message test"
        let expectedURL = try XCTUnwrap(URL(string: "https://test.ps.com/mobile/api/v1/log"))
        mockSession.stubRequest(url: expectedURL, data: nil, response: nil, error: nil)

        // When
        sut.log(eventType: .error, message: message)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, expectedURL)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
    }

    func test_3DSLog_internalSdkError() throws {
        // Given
        let message = "3DS Internal sdk error message"
        let expectedURL = try XCTUnwrap(URL(string: "https://test.ps.com/threedsecure/v2/log"))
        mockSession.stubRequest(url: expectedURL, data: nil, response: nil, error: nil)

        // When
        sut.log3DS(eventType: .internalSDKError, message: message)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, expectedURL)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
    }

    func test_3DSLog_validationError() throws {
        // Given
        let message = "3DS Validation error message"
        let expectedURL = try XCTUnwrap(URL(string: "https://test.ps.com/threedsecure/v2/log"))
        mockSession.stubRequest(url: expectedURL, data: nil, response: nil, error: nil)

        // When
        sut.log3DS(eventType: .validationError, message: message)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, expectedURL)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
    }

    func test_3DSLog_successEvent() throws {
        // Given
        let message = "3DS Success event message"
        let expectedURL = try XCTUnwrap(URL(string: "https://test.ps.com/threedsecure/v2/log"))
        mockSession.stubRequest(url: expectedURL, data: nil, response: nil, error: nil)

        // When
        sut.log3DS(eventType: .success, message: message)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, expectedURL)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
    }

    func test_3DSLog_networkError() throws {
        // Given
        let message = "3DS Network error message"
        let expectedURL = try XCTUnwrap(URL(string: "https://test.ps.com/threedsecure/v2/log"))
        mockSession.stubRequest(url: expectedURL, data: nil, response: nil, error: nil)

        // When
        sut.log3DS(eventType: .networkError, message: message)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, expectedURL)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
    }
}
