//
//  PSApplePayTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PassKit
@testable import PaysafeApplePay
import XCTest

final class PSApplePayTests: XCTestCase {
    var sut: PSApplePay!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        sut = PSApplePay(
            merchantIdentifier: "merchantIdentifier",
            countryCode: "US",
            supportedNetworks: [
                SupportedNetwork(
                    network: .amex,
                    capability: .both
                ),
                SupportedNetwork(
                    network: .visa,
                    capability: .credit
                ),
                SupportedNetwork(
                    network: .masterCard,
                    capability: .both
                ),
                SupportedNetwork(
                    network: .discover,
                    capability: .both
                )
            ]
        )
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_paymentRequest() {
        // Given
        let merchantIdentifier = "merchantIdentifier"
        let countryCode = "US"
        let supportedNetworks: [SupportedNetwork] = [
            SupportedNetwork(
                network: .amex,
                capability: .both
            ),
            SupportedNetwork(
                network: .visa,
                capability: .credit
            ),
            SupportedNetwork(
                network: .masterCard,
                capability: .both
            ),
            SupportedNetwork(
                network: .discover,
                capability: .both
            )
        ]
        // Then
        XCTAssertEqual(sut.paymentRequest.merchantIdentifier, merchantIdentifier)
        XCTAssertEqual(Set(sut.paymentRequest.supportedNetworks), Set(supportedNetworks.map(\.network)))
        XCTAssertEqual(sut.paymentRequest.merchantCapabilities, [.threeDSecure, .debit, .credit])
        XCTAssertEqual(sut.paymentRequest.countryCode, countryCode)
    }

    func test_initiateApplePayFlow_requestBillingAddress_false() throws {
        // Given
        let currencyCode = "USD"
        let amount: Double = 10
        let psApplePay = PSApplePayItem(
            label: "Test item",
            requestBillingAddress: false
        )

        // When
        sut.initiateApplePayFlow(
            currencyCode: currencyCode,
            amount: amount,
            psApplePay: psApplePay
        )
        .sink { applePayResult in
            guard case let .success(initializeApplePayResponse) = applePayResult else { return }
            initializeApplePayResponse.completion?(.success, nil)
        }
        .store(in: &cancellables)

        // Then
        let authorizationController = try XCTUnwrap(sut.authorizationController)
        let paymentRequest = sut.paymentRequest
        authorizationController.delegate?.paymentAuthorizationController?(
            authorizationController,
            didAuthorizePayment: PKPayment(),
            handler: { result in
                XCTAssertEqual(result.status, .success)
                XCTAssertEqual(paymentRequest.currencyCode, currencyCode)
                XCTAssertEqual(
                    paymentRequest.paymentSummaryItems,
                    [
                        PKPaymentSummaryItem(
                            label: psApplePay.label,
                            amount: NSDecimalNumber(value: amount)
                        )
                    ]
                )
                XCTAssert(paymentRequest.requiredBillingContactFields.isEmpty)
            }
        )
    }

    func test_initiateApplePayFlow_requestBillingAddress_true() throws {
        // Given
        let currencyCode = "USD"
        let amount: Double = 10
        let psApplePay = PSApplePayItem(
            label: "Test item",
            requestBillingAddress: true
        )

        // When
        sut.initiateApplePayFlow(
            currencyCode: currencyCode,
            amount: amount,
            psApplePay: psApplePay
        )
        .sink { applePayResult in
            guard case let .success(initializeApplePayResponse) = applePayResult else { return }
            initializeApplePayResponse.completion?(.success, nil)
        }
        .store(in: &cancellables)

        // Then
        let authorizationController = try XCTUnwrap(sut.authorizationController)
        let paymentRequest = sut.paymentRequest
        authorizationController.delegate?.paymentAuthorizationController?(
            authorizationController,
            didAuthorizePayment: PKPayment(),
            handler: { result in
                XCTAssertEqual(result.status, .success)
                XCTAssertEqual(paymentRequest.currencyCode, currencyCode)
                XCTAssertEqual(
                    paymentRequest.paymentSummaryItems,
                    [
                        PKPaymentSummaryItem(
                            label: psApplePay.label,
                            amount: NSDecimalNumber(value: amount)
                        )
                    ]
                )
                XCTAssertEqual(paymentRequest.requiredBillingContactFields,
                               [
                                   .name,
                                   .emailAddress,
                                   .postalAddress,
                                   .phoneNumber
                               ])
            }
        )
    }
}
