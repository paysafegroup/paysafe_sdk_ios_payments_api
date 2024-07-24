//
//  PaymentMethodTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon
import XCTest

class PaymentMethodTests: XCTestCase {
    func testPaymentMethodInitialization() {
        // Given
        let paymentMethodType = PaymentType.card
        let currencyCode = "USD"
        let accountId = "account123"
        let accountConfiguration = AccountConfiguration(
            id: "config1",
            isApplePay: true,
            cardTypeConfig: [:],
            clientId: "client123"
        )

        // When
        let paymentMethod = PaymentMethod(
            paymentMethod: paymentMethodType,
            currencyCode: currencyCode,
            accountId: accountId,
            accountConfiguration: accountConfiguration
        )

        // Then
        XCTAssertEqual(paymentMethod.paymentMethod, paymentMethodType)
        XCTAssertEqual(paymentMethod.currencyCode, currencyCode)
        XCTAssertEqual(paymentMethod.accountId, accountId)
        XCTAssertEqual(paymentMethod.accountConfiguration?.id, accountConfiguration.id)
        XCTAssertEqual(paymentMethod.accountConfiguration?.isApplePay, accountConfiguration.isApplePay)
        XCTAssertEqual(paymentMethod.accountConfiguration?.clientId, accountConfiguration.clientId)
    }

    func testPaymentMethodResponseConversion() {
        // Given
        let paymentMethodResponse = PaymentMethodResponse(
            paymentMethod: .card,
            currencyCode: "CAD",
            accountId: "account456",
            accountConfiguration: AccountConfigurationResponse(
                id: "config2",
                isApplePay: false,
                clientId: "client456",
                cardTypeConfig: [:]
            )
        )

        // When
        let paymentMethod = paymentMethodResponse.toPaymentMethod()

        // Then
        XCTAssertEqual(paymentMethod.paymentMethod, paymentMethodResponse.paymentMethod)
        XCTAssertEqual(paymentMethod.currencyCode, paymentMethodResponse.currencyCode)
        XCTAssertEqual(paymentMethod.accountId, paymentMethodResponse.accountId)
        XCTAssertEqual(paymentMethod.accountConfiguration?.id, paymentMethodResponse.accountConfiguration?.id)
        XCTAssertEqual(paymentMethod.accountConfiguration?.isApplePay, paymentMethodResponse.accountConfiguration?.isApplePay)
        XCTAssertEqual(paymentMethod.accountConfiguration?.clientId, paymentMethodResponse.accountConfiguration?.clientId)
    }
}
