//
//  Paysafe3DSTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
@testable import Paysafe3DS
@testable import CommonMocks
import PaysafeCommon
import XCTest

final class Paysafe3DSTests: XCTestCase {
    var sut: Paysafe3DS!
    var mockSession: URLSessionMock!
    var mockNetworkingService: PSNetworkingService!

    override func setUp() {
        super.setUp()
        sut = Paysafe3DS(
            apiKey: "am9objpkb2UK",
            environment: .staging
        )
        mockSession = URLSessionMock()
        mockNetworkingService = PSNetworkingService(
            session: mockSession,
            authorizationKey: "apiKey",
            correlationId: "testCorrelationId",
            sdkVersion: "1.0.0"
        )
        sut.networkingService = mockNetworkingService
        sut.session = CardinalSessionMock()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_initiate3DSFlow_success() throws {
        // Given
        let expectation = expectation(description: "Initiate 3DS flow expectation.")
        let paysafe3DSOptions = Paysafe3DSOptions(
            accountId: "accountId",
            bin: "cardBin"
        )
        let mockData = try XCTUnwrap(JWTResponse.jsonMock().data(using: .utf8))
        let getJWTUrl = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/threedsecure/v2/jwt"))
        let mockResponse = try XCTUnwrap(HTTPURLResponse(url: getJWTUrl, statusCode: 200, httpVersion: nil, headerFields: nil))
        mockSession.stubRequest(url: getJWTUrl, data: mockData, response: mockResponse, error: nil)

        // When
        sut.initiate3DSFlow(
            using: paysafe3DSOptions,
            and: .both
        ) { result in
            switch result {
            case let .success(deviceFingerprintingId):
                // Then
                XCTAssertEqual(deviceFingerprintingId, "deviceFingerprintingId")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiate3DSFlow_failure() throws {
        // Given
        let expectation = expectation(description: "Initiate 3DS flow expectation.")
        let paysafe3DSOptions = Paysafe3DSOptions(
            accountId: "accountId",
            bin: "cardBin"
        )
        let mockData = try XCTUnwrap(JWTResponse.jsonMock().data(using: .utf8))
        let getJWTUrl = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/threedsecure/v2/jwt"))
        let mockResponse = try XCTUnwrap(HTTPURLResponse(url: getJWTUrl, statusCode: 400, httpVersion: nil, headerFields: nil))
        let expectedError = URLError(URLError.Code.badServerResponse)
        mockSession.stubRequest(url: getJWTUrl, data: mockData, response: mockResponse, error: expectedError)
        sut.configuration.supportedUI = .html
        
        // When
        sut.initiate3DSFlow(
            using: paysafe3DSOptions
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, received success.")
            case let .failure(error):
                // Then
                XCTAssertEqual(error.errorCode, .genericAPIError)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_startChallenge_success() throws {
        // Given
        let expectation = expectation(description: "Start challenge expectation.")
        let challengePayload = SDKChallengePayload(
            id: "id",
            transactionId: "transactionId",
            payload: "payload",
            accountId: "accountId"
        )
        let payload = try JSONEncoder().encode(challengePayload).base64EncodedString()

        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/threedsecure/v2/accounts/\(challengePayload.accountId)/authentications/\(challengePayload.id)/finalize"))
        let mockResponse = try XCTUnwrap(HTTPURLResponse(url: finalizeURL, statusCode: 200, httpVersion: nil, headerFields: nil))
        mockSession.stubRequest(url: finalizeURL, data: nil, response: mockResponse, error: nil)

        // When
        sut.startChallenge(
            using: payload
        ) { result in
            switch result {
            case let .success(authenticationId):
                // Then
                XCTAssertEqual(authenticationId, challengePayload.id)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        }
        sut.cardinalSession(cardinalSession: nil, stepUpValidated: nil, serverJWT: "serverJWT")

        wait(for: [expectation], timeout: 1.0)
    }

    func test_startChallenge_failure() throws {
        // Given
        let expectation = expectation(description: "Start challenge expectation.")
        let challengePayload = SDKChallengePayload(
            id: "id",
            transactionId: "transactionId",
            payload: "payload",
            accountId: "accountId"
        )
        let payload = try JSONEncoder().encode(challengePayload).base64EncodedString()

        // When
        sut.startChallenge(
            using: payload
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, received success.")
            case let .failure(error):
                // Then
                XCTAssertEqual(error.errorCode, .genericAPIError)
                expectation.fulfill()
            }
        }
        sut.cardinalSession(cardinalSession: nil, stepUpValidated: nil, serverJWT: nil)

        wait(for: [expectation], timeout: 1.0)
    }
}
