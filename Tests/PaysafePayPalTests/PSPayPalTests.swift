//
//  PSPayPalTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import CorePayments
@testable import PayPalNativePayments
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
        // When
        let sut = PSPayPal(renderType: .native(clientId: "clientId", environment: .sandbox))

        // Then
        guard case let .native(clientId, environment) = sut.renderType else {
            return XCTFail("Expected native render type, received web.")
        }
        XCTAssertNotNil(sut)
        XCTAssertEqual(clientId, "clientId")
        XCTAssertEqual(environment.toCoreEnvironment, .sandbox)
    }

    func test_init_nativeRenderType_liveEnvironment() {
        // When
        let sut = PSPayPal(renderType: .native(clientId: "clientId", environment: .live))

        // Then
        guard case let .native(clientId, environment) = sut.renderType else {
            return XCTFail("Expected native render type, received web.")
        }
        XCTAssertNotNil(sut)
        XCTAssertEqual(clientId, "clientId")
        XCTAssertEqual(environment.toCoreEnvironment, .live)
    }

    func test_init_webRenderType() {
        // When
        let sut = PSPayPal(renderType: .web)

        // Then
        XCTAssertNotNil(sut)
    }

    func test_initiatePayPalFlow_nativeRenderType_success() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .native(clientId: "clientId", environment: .sandbox))
        let orderId = "orderId"
        let payerId = "payerId"
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
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

        let payPalClient = try XCTUnwrap(sut.payPalClient)
        let result = PayPalNativeCheckoutResult(orderID: orderId, payerID: payerId)
        sut.paypal(payPalClient, didFinishWithResult: result)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_nativeRenderType_failed() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .native(clientId: "clientId", environment: .sandbox))
        let orderId = "orderId"
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
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

        let payPalClient = try XCTUnwrap(sut.payPalClient)
        let mockError = CorePayments.CoreSDKError(code: nil, domain: nil, errorDescription: nil)
        sut.paypal(payPalClient, didFinishWithError: mockError)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_nativeRenderType_cancelled() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .native(clientId: "clientId", environment: .sandbox))
        let orderId = "orderId"
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
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

        let payPalClient = try XCTUnwrap(sut.payPalClient)
        sut.paypalDidCancel(payPalClient)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_successUrlRedirect() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .web)
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: "orderId",
            payPalLinks: payPalLinks
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

        let safariViewController = try XCTUnwrap(sut.safariViewController)
        let successUrl = try XCTUnwrap(URL(string: payPalLinks.successUrl))
        sut.safariViewController(safariViewController, initialLoadDidRedirectTo: successUrl)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_failedUrlRedirect() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .web)
        let orderId = "orderId"
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
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

        let safariViewController = try XCTUnwrap(sut.safariViewController)
        let failedUrl = try XCTUnwrap(URL(string: payPalLinks.failedUrl))
        sut.safariViewController(safariViewController, initialLoadDidRedirectTo: failedUrl)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_cancelledUrlRedirect() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .web)
        let orderId = "orderId"
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
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

        let safariViewController = try XCTUnwrap(sut.safariViewController)
        let cancelledUrl = try XCTUnwrap(URL(string: payPalLinks.cancelledUrl))
        sut.safariViewController(safariViewController, initialLoadDidRedirectTo: cancelledUrl)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_defaultUrlRedirect() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .web)
        let orderId = "orderId"
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
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

        let safariViewController = try XCTUnwrap(sut.safariViewController)
        let defaultUrl = try XCTUnwrap(URL(string: payPalLinks.defaultUrl))
        sut.safariViewController(safariViewController, initialLoadDidRedirectTo: defaultUrl)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_initiatePayPalFlow_webRenderType_userCancelled() throws {
        // Given
        let expectation = expectation(description: "Initiate PayPal flow expectation.")
        let sut = PSPayPal(renderType: .web)
        let orderId = "orderId"
        let payPalLinks = PSPayPalLinks.createMock()

        // When
        sut.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
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

        let safariViewController = try XCTUnwrap(sut.safariViewController)
        sut.safariViewControllerDidFinish(safariViewController)

        wait(for: [expectation], timeout: 1.0)
    }
}

private extension PSPayPalLinks {
    static func createMock() -> PSPayPalLinks {
        PSPayPalLinks(
            redirectUrl: "https://paysafe.com/redirect",
            successUrl: "https://paysafe.com/return/success",
            failedUrl: "https://paysafe.com/return/failed",
            cancelledUrl: "https://paysafe.com/return/cancelled",
            defaultUrl: "https://paysafe.com/return"
        )
    }
}
