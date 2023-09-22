//
//  PSPayPalTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import CorePayments
@testable import PayPalNativePayments
@testable import PayPalWebPayments
@testable import PaysafePayPal
import XCTest

final class PSPayPalTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func test_init_nativeRenderType_sandboxEnvironment() {
        // Given
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .sandbox
        let renderType: PSPayPalRenderType = .native
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )

        // Then
        guard sut.renderType == .native else {
            return XCTFail("Expected native render type, received web.")
        }
        XCTAssertNotNil(sut)
        XCTAssertEqual(clientId, "clientId")
        XCTAssertEqual(environment.toCoreEnvironment, .sandbox)
    }

    func test_init_nativeRenderType_liveEnvironment() {
        // Given
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .live
        let renderType: PSPayPalRenderType = .native
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )
        // Then
        guard sut.renderType == .native else {
            return XCTFail("Expected native render type, received web.")
        }
        XCTAssertNotNil(sut)
        XCTAssertEqual(clientId, "clientId")
        XCTAssertEqual(environment.toCoreEnvironment, .live)
    }

    func test_init_webRenderType_sandboxEnvironment() {
        // Given
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .sandbox
        let renderType: PSPayPalRenderType = .web
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )

        // Then
        guard sut.renderType == .web else {
            return XCTFail("Expected native render type, received web.")
        }
        XCTAssertNotNil(sut)
        XCTAssertEqual(clientId, "clientId")
        XCTAssertEqual(environment.toCoreEnvironment, .sandbox)
    }

    func test_initiatePayPalFlow_nativeRenderType_success() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .live
        let renderType: PSPayPalRenderType = .native
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )
        let orderId = "orderId"
        let payerId = "payerId"

        // When
        sut.initiatePayPalFlow(
            orderId: orderId
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { result in
            // Then
            XCTAssertEqual(result, .success)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        let payPalClient = try XCTUnwrap(sut.payPalNativeClient)
        let result = PayPalNativeCheckoutResult(orderID: orderId, payerID: payerId)
        sut.paypal(payPalClient, didFinishWithResult: result)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_nativeRenderType_failed() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .live
        let renderType: PSPayPalRenderType = .native
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )
        let orderId = "orderId"

        // When
        sut.initiatePayPalFlow(
            orderId: orderId
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { result in
            // Then
            XCTAssertEqual(result, .failed)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        let payPalClient = try XCTUnwrap(sut.payPalNativeClient)
        let mockError = CorePayments.CoreSDKError(code: nil, domain: nil, errorDescription: nil)
        sut.paypal(payPalClient, didFinishWithError: mockError)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_nativeRenderType_cancelled() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .sandbox
        let renderType: PSPayPalRenderType = .native
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )
        let orderId = "orderId"

        // When
        sut.initiatePayPalFlow(
            orderId: orderId
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { result in
            // Then
            XCTAssertEqual(result, .cancelled)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        let payPalClient = try XCTUnwrap(sut.payPalNativeClient)
        sut.paypalDidCancel(payPalClient)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_success() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .sandbox
        let renderType: PSPayPalRenderType = .web
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )
        let orderId = "orderId"
        let payerId = "payerId"

        // When
        sut.initiatePayPalFlow(
            orderId: orderId
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { result in
            // Then
            XCTAssertEqual(result, .success)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        let payPalWebClient = try XCTUnwrap(sut.payPalWebClient)
        let result = PayPalWebCheckoutResult(
            orderID: orderId,
            payerID: payerId
        )
        sut.payPal(payPalWebClient, didFinishWithResult: result)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_error() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .sandbox
        let renderType: PSPayPalRenderType = .web
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )
        let orderId = "orderId"

        // When
        sut.initiatePayPalFlow(
            orderId: orderId
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { result in
            // Then
            XCTAssertEqual(result, .failed)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        let payPalWebClient = try XCTUnwrap(sut.payPalWebClient)
        let mockError = CorePayments.CoreSDKError(code: nil, domain: nil, errorDescription: nil)
        sut.payPal(payPalWebClient, didFinishWithError: mockError)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_cancelled() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let clientId = "clientId"
        let environment: PSPayPalEnvironment = .sandbox
        let renderType: PSPayPalRenderType = .web
        let sut = PSPayPal(
            clientId: clientId,
            environment: environment,
            renderType: renderType
        )
        let orderId = "orderId"

        // When
        sut.initiatePayPalFlow(
            orderId: orderId
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { result in
            // Then
            XCTAssertEqual(result, .cancelled)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        let payPalWebClient = try XCTUnwrap(sut.payPalWebClient)
        sut.payPalDidCancel(payPalWebClient)

        wait(for: [expectation], timeout: 1.0)
    }
}
