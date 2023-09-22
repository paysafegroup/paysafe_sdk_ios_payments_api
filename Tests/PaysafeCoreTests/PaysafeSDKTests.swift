//
//  PaysafeSDKTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCommon
@testable import PaysafeCore
import XCTest

final class PaysafeSDKTests: XCTestCase {
    var sut: PaysafeSDK!

    override func setUp() {
        super.setUp()
        sut = PaysafeSDK.shared
    }

    override func tearDown() {
        sut.psAPIClient = nil
        sut = nil
        super.tearDown()
    }

    func test_shared_PaysafeSDK() {
        XCTAssertTrue(PaysafeSDK.shared === PaysafeSDK.shared)
    }

    func test_setup_success() {
        // Given
        let apiKey = "apiKey"
        let environment: PaysafeEnvironment = .test

        XCTAssertNil(sut.psAPIClient)

        // When
        sut.setup(
            apiKey: apiKey,
            environment: environment
        ) { result in
            guard case let .success(isInitialized) = result else {
                return XCTFail("Expected a success PaysafeSDK setup result.")
            }
            // Then
            XCTAssertTrue(isInitialized)
            XCTAssertNotNil(self.sut.psAPIClient)
        }
    }

    func test_setup_failure_invalidAPIKey() {
        // Given
        let apiKey = ""
        let environment: PaysafeEnvironment = .test

        XCTAssertNil(sut.psAPIClient)

        // When
        sut.setup(
            apiKey: apiKey,
            environment: environment
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PaysafeSDK setup result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreInvalidAPIKey)
            XCTAssertNil(self.sut.psAPIClient)
        }
    }

    func test_setup_failure_unavailableEnvironment() {
        // Given
        let apiKey = "apiKey"
        let environment: PaysafeEnvironment = .production

        XCTAssertNil(sut.psAPIClient)

        // When
        sut.setup(
            apiKey: apiKey,
            environment: environment
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PaysafeSDK setup result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreUnavailableEnvironment)
            XCTAssertNil(self.sut.psAPIClient)
        }
    }

    func test_getPSAPIClient() {
        // Given
        let apiKey = "apiKey"
        let environment: PaysafeEnvironment = .test

        XCTAssertNil(sut.getPSAPIClient())

        // When
        sut.setup(
            apiKey: apiKey,
            environment: environment
        ) { result in
            guard case let .success(isInitialized) = result else {
                return XCTFail("Expected a success PaysafeSDK setup result.")
            }
            // Then
            XCTAssertTrue(isInitialized)
            XCTAssertNotNil(self.sut.getPSAPIClient())
        }
    }

    func test_getMerchantReferenceNumber() throws {
        // When
        let merchantReferenceNumber1 = sut.getMerchantReferenceNumber()
        let merchantReferenceNumber2 = sut.getMerchantReferenceNumber()

        // Then
        XCTAssertNotEqual(merchantReferenceNumber1, merchantReferenceNumber2)
        let merchantReferenceNumber1UUID = try XCTUnwrap(UUID(uuidString: merchantReferenceNumber1))
        let merchantReferenceNumber2UUID = try XCTUnwrap(UUID(uuidString: merchantReferenceNumber2))
        XCTAssertNotEqual(merchantReferenceNumber1UUID, merchantReferenceNumber2UUID)
    }
}
