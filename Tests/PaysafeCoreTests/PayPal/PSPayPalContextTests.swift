//
//  PSPayPalContextTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCommon
@testable import PaysafeCore
import XCTest

final class PSPayPalContextTests: XCTestCase {
    func test_initialize_success() {
        // When
        PSPayPalContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSPayPalContext result.")
            }
            // Then
            XCTAssertNotNil(sut)
        }
    }

    func test_initialize_failure_invalidCurrencyCode() {
        // When
        PSPayPalContext.createSUT(
            currencyCodeValidationShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSPayPalContext result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreInvalidCurrencyCode)
        }
    }

    func test_initialize_failure_getPaymentMethod() {
        // When
        PSPayPalContext.createSUT(
            getPaymentMethodShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSPayPalContext result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreMerchantAccountConfigurationError)
        }
    }

    func test_initialize_failure_payPalValidation() {
        // When
        PSPayPalContext.createSUT(
            getPaymentMethodShouldSucceedPayPalValidation: false,
            getPaymentMethodShouldFailPayPalValidation: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSPayPalContext result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreInvalidAccountId)
        }
    }

    func test_tokenize_success() {
        // Given
        PSPayPalContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSPayPalContext result.")
            }
            let options = PSPayPalTokenizeOptions.createMock()

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

    func test_tokenize_failure() {
        // Given
        PSPayPalContext.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSPayPalContext result.")
            }
            let options = PSPayPalTokenizeOptions.createMock()
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

private extension PSPayPalContext {
    static func createSUT(
        currencyCodeValidationShouldFail: Bool = false,
        getPaymentMethodShouldFail: Bool = false,
        getPaymentMethodShouldSucceedPayPalValidation: Bool = true,
        getPaymentMethodShouldFailPayPalValidation: Bool = false,
        completion: @escaping PSPayPalContextInitializeBlock
    ) {
        let mockAPIClient = PSAPIClientMock(
            apiKey: "apiKey",
            environment: .test
        )
        mockAPIClient.getPaymentMethodShouldFail = getPaymentMethodShouldFail
        mockAPIClient.getPaymentMethodShouldSucceedPayPalValidation = getPaymentMethodShouldSucceedPayPalValidation
        mockAPIClient.getPaymentMethodShouldFailPayPalValidation = getPaymentMethodShouldFailPayPalValidation
        PaysafeSDK.shared.psAPIClient = mockAPIClient

        let currencyCode = !currencyCodeValidationShouldFail ? "USD" : "INVALID"
        let accountId = "1001456390"

        PSPayPalContext.initialize(
            currencyCode: currencyCode,
            accountId: accountId
        ) { result in
            switch result {
            case let .success(payPalContext):
                payPalContext.psPayPal = PSPayPalMock(renderType: .web)
                completion(.success(payPalContext))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private extension PSPayPalTokenizeOptions {
    static func createMock() -> PSPayPalTokenizeOptions {
        PSPayPalTokenizeOptions(
            amount: 1000,
            merchantRefNum: UUID().uuidString,
            customerDetails: CustomerDetails(
                billingDetails: BillingDetails(
                    country: "US",
                    zip: "33172",
                    state: "FL",
                    city: nil,
                    street: nil,
                    street1: nil,
                    street2: nil,
                    phone: nil,
                    nickName: nil
                ),
                profile: nil
            ),
            accountId: "1001693410",
            currencyCode: "USD",
            consumerId: "consumerId",
            recipientDescription: "recipientDescription",
            language: .US,
            shippingPreference: .getFromFile,
            consumerMessage: "consumerMessage",
            orderDescription: "orderDescription"
        )
    }
}
