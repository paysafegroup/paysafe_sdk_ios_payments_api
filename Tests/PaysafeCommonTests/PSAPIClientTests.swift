//
//  PSAPIClientTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import XCTest

@testable import PaysafeCommon
@testable import CommonMocks

final class PSAPIClientTests: XCTestCase {
    var sut: PSAPIClient!
    var mockSession: URLSessionMock!
    var mockNetworkingService: PSNetworkingService!

    override func setUp() {
        super.setUp()
        mockSession = URLSessionMock()
        mockNetworkingService = PSNetworkingService(
            session: mockSession,
            authorizationKey: "apiKey",
            correlationId: "testCorrelationId",
            sdkVersion: "1.0.0"
        )
        sut = PSAPIClient(
            apiKey: "am9objpkb2UK",
            environment: .test
        )
        sut.networkingService = mockNetworkingService
    }

    override func tearDown() {
        mockSession = nil
        mockNetworkingService = nil
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
        XCTAssertFalse(PSJailbreakChecker.isJailbroken())
    }

    func test_getPaymentMethod_success() throws {
        // Given
        let expectation = expectation(description: "Fetches the available payment method for the selected accountId successfully.")
        let paymentType: PaymentType = .card
        let currencyCode = "USD"
        let accountId = "acc123"
        let mockData = try XCTUnwrap(PaymentMethodsResponse.jsonMock().data(using: .utf8))
        let getAvailablePaymentsURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/paymentmethods?currencyCode=USD"))
        let mockResponse = try XCTUnwrap(HTTPURLResponse(url: getAvailablePaymentsURL, statusCode: 200, httpVersion: nil, headerFields: nil))
        mockSession.stubRequest(url: getAvailablePaymentsURL, data: mockData, response: mockResponse, error: nil)

        // When
        sut.getPaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId
        ) { result in
            switch result {
            case let .success(paymentMethod):
                // Then
                XCTAssertEqual(paymentMethod.accountId, accountId)
                XCTAssertEqual(paymentMethod.paymentMethod, paymentType)
                XCTAssertEqual(paymentMethod.currencyCode, currencyCode)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_getAvailablePaymentMethod_unavailablePaymentMethod() throws {
        // Given
        let expectation = expectation(description: "Unavailable payment method for the selected accountId.")
        let currencyCode = "USD"
        let accountId = "acc1234"
        let correlationId = PaysafeSDK.shared.correlationId
        let error: PSError = .coreInvalidAccountId(correlationId, message: "Invalid account id for unknown.")
        let mockData = try XCTUnwrap(PaymentMethodsResponse.jsonMock().data(using: .utf8))
        let getAvailablePaymentsURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/paymentmethods?currencyCode=USD"))
        let mockResponse = try XCTUnwrap(HTTPURLResponse(url: getAvailablePaymentsURL, statusCode: 200, httpVersion: nil, headerFields: nil))
        mockSession.stubRequest(url: getAvailablePaymentsURL, data: mockData, response: mockResponse, error: nil)

        // When
        sut.getPaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but received success")
            case let .failure(receivedError):
                // Then
                XCTAssertEqual(receivedError.errorCode, error.errorCode, "Received error should match the stubbed error")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_getAvailablePaymentMethod_failure() throws {
        // Given
        let expectation = expectation(description: "Handles failure in fetching payment methods")
        let currencyCode = "USD"
        let accountId = "acc123"
        let error = URLError(URLError.Code.badServerResponse)
        let getAvailablePaymentsURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/paymentmethods?currencyCode=USD"))
        mockSession.stubRequest(url: getAvailablePaymentsURL, data: nil, response: nil, error: error)

        // When
        sut.getPaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but received success")
            case let .failure(receivedError):
                // Then
                XCTAssertEqual(receivedError.errorCode, .coreFailedToFetchAvailablePayments)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
