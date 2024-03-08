//
//  PSApplePayContextTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PassKit
import PaysafeApplePay
import PaysafeCommon
@testable import PaysafeCore
import XCTest

final class PSApplePayContextTests: XCTestCase {
    func test_initialize_success() {
        // When
        PSApplePayContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSApplePayContext result.")
            }
            // Then
            XCTAssertNotNil(sut)
        }
    }

    func test_initialize_failure_invalidCurrencyCode() {
        // When
        PSApplePayContext.createSUT(
            currencyCodeValidationShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSApplePayContext result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreInvalidCurrencyCode)
        }
    }

    func test_initialize_failure_invalidAccountId() {
        // When
        PSApplePayContext.createSUT(
            accountIdValidationShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSApplePayContext result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .invalidAccountIdFormat)
        }
    }

    func test_initialize_failure_getPaymentMethod() {
        // When
        PSApplePayContext.createSUT(
            getPaymentMethodShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSApplePayContext result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreMerchantAccountConfigurationError)
        }
    }

    func test_initialize_failure_applePayValidation() {
        // When
        PSApplePayContext.createSUT(
            getPaymentMethodShouldSucceedApplePayValidation: false,
            getPaymentMethodShouldFailApplePayValidation: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSApplePayContext result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreInvalidAccountId)
        }
    }

    func test_applePayButton() {
        // Given
        PSApplePayContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSApplePayContext result.")
            }
            // When
            let applePayButton = sut.applePayButton(
                type: .buy,
                style: .automatic,
                action: nil
            )

            // Then
            XCTAssertNotNil(applePayButton)
        }
    }

    func test_applePaySwiftUIButton() {
        // Given
        PSApplePayContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSApplePayContext result.")
            }
            // When
            let applePayButton = sut.applePaySwiftUIButton(
                type: .buy,
                style: .automatic,
                action: nil
            )

            // Then
            XCTAssertNotNil(applePayButton)
        }
    }

    func test_tokenize_success() {
        // Given
        PSApplePayContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSApplePayContext result.")
            }
            let options = PSApplePayTokenizeOptions.createMock()

            // When
            sut.tokenize(using: options) { tokenizeResult in
                switch tokenizeResult {
                case let .success(paymentHandleToken):
                    // Then
                    XCTAssertFalse(paymentHandleToken.isEmpty)
                    XCTAssertEqual(paymentHandleToken.count, 16)
                case .failure:
                    XCTFail("Expected a successful tokenize response.")
                }
            }
        }
    }

    func test_tokenize_success_statusFailed() {
        // Given
        PSApplePayContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSApplePayContext result.")
            }
            let options = PSApplePayTokenizeOptions.createMock()
            guard let mockAPIClient = sut.psAPIClient as? PSAPIClientMock else {
                return XCTFail("PSAPIClient couln't be casted to PSAPIClientMock.")
            }

            mockAPIClient.expectedTokenizeResultStatus = .failed

            // When
            sut.tokenize(using: options) { tokenizeResult in
                switch tokenizeResult {
                case let .success(paymentHandleToken):
                    XCTAssertFalse(paymentHandleToken.isEmpty)
                    XCTAssertEqual(paymentHandleToken.count, 16)
                case let .failure(error):
                    // Then
                    XCTFail("Expected a successful tokenize response.")
                }
            }
        }
    }

    func test_tokenize_failure() {
        // Given
        PSApplePayContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSApplePayContext result.")
            }
            let options = PSApplePayTokenizeOptions.createMock()
            guard let mockAPIClient = sut.psAPIClient as? PSAPIClientMock else {
                return XCTFail("PSAPIClient couln't be casted to PSAPIClientMock.")
            }
            mockAPIClient.tokenizeShouldFail = true

            // When
            sut.tokenize(using: options) { tokenizeResult in
                switch tokenizeResult {
                case .success:
                    XCTFail("Expected a failed tokenize response.")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error.errorCode, .genericAPIError)
                }
            }
        }
    }
}

private extension PSApplePayContext {
    static func createSUT(
        currencyCodeValidationShouldFail: Bool = false,
        accountIdValidationShouldFail: Bool = false,
        getPaymentMethodShouldFail: Bool = false,
        getPaymentMethodShouldSucceedApplePayValidation: Bool = true,
        getPaymentMethodShouldFailApplePayValidation: Bool = false,
        completion: @escaping PSApplePayContextInitializeBlock
    ) {
        let mockAPIClient = PSAPIClientMock(
            apiKey: "am9objpkb2UK",
            environment: .test
        )
        mockAPIClient.getPaymentMethodShouldFail = getPaymentMethodShouldFail
        mockAPIClient.getPaymentMethodShouldSucceedApplePayValidation = getPaymentMethodShouldSucceedApplePayValidation
        mockAPIClient.getPaymentMethodShouldFailApplePayValidation = getPaymentMethodShouldFailApplePayValidation
        PaysafeSDK.shared.psAPIClient = mockAPIClient

        let currencyCode = !currencyCodeValidationShouldFail ? "USD" : "INVALID"
        let accountId = !accountIdValidationShouldFail ? "1001456390" : "INVALID"
        let merchantIdentifier = "merchantIdentifier"
        let countryCode = "US"

        PSApplePayContext.initialize(
            currencyCode: currencyCode,
            accountId: accountId,
            merchantIdentifier: merchantIdentifier,
            countryCode: countryCode
        ) { result in
            switch result {
            case let .success(applePayContext):
                applePayContext.psApplePay = PSApplePayMock(
                    merchantIdentifier: merchantIdentifier,
                    countryCode: countryCode,
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
                completion(.success(applePayContext))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private extension PSApplePayTokenizeOptions {
    static func createMock() -> PSApplePayTokenizeOptions {
        PSApplePayTokenizeOptions(
            amount: 100,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: "1001456390",
            billingDetails: BillingDetails(
                country: "US",
                zip: "400523",
                state: nil,
                city: nil,
                street: nil,
                street1: nil,
                street2: nil,
                phone: nil,
                nickName: "John"
            ),
            accountId: "testApplePayAccountId",
            psApplePay: PSApplePayItem(
                label: "Test item",
                requestBillingAddress: false
            )
        )
    }
}
