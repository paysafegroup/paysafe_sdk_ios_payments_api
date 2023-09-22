//
//  PSCardFormTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCommon
@testable import PaysafeCore
import XCTest

final class PSCardFormTests: XCTestCase {
    var sut: PSCardForm!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_initialize_success() {
        // When
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSCardForm result.")
            }
            self.sut = sut

            // Then
            XCTAssertNotNil(sut)
        }
    }

    func test_initialize_success_UIKit() {
        // When
        PSCardForm.createSUT(configuration: .UIKit) { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSCardForm result.")
            }
            self.sut = sut

            // Then
            XCTAssertNotNil(sut)
            XCTAssertNotNil(sut.cardNumberView)
            XCTAssertNotNil(sut.cardholderNameView)
            XCTAssertNotNil(sut.cardExpiryView)
            XCTAssertNotNil(sut.cardCVVView)
        }
    }

    func test_initialize_success_SwiftUI() {
        // When
        PSCardForm.createSUT(configuration: .SwiftUI) { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success PSCardForm result.")
            }
            self.sut = sut

            // Then
            XCTAssertNotNil(sut)
            XCTAssertNotNil(sut.cardNumberView)
            XCTAssertNotNil(sut.cardholderNameView)
            XCTAssertNotNil(sut.cardExpiryView)
            XCTAssertNotNil(sut.cardCVVView)
        }
    }

    func test_initialize_failure_invalidCurrencyCode() {
        // When
        PSCardForm.createSUT(
            currencyCodeValidationShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSCardForm result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreInvalidCurrencyCode)
        }
    }

    func test_initialize_failure_invalidAccountId() {
        // When
        PSCardForm.createSUT(
            accountIdValidationShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSCardForm result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .invalidAccountIdFormat)
        }
    }

    func test_initialize_failure_getPaymentMethod() {
        // When
        PSCardForm.createSUT(
            getPaymentMethodShouldFail: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSCardForm result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreMerchantAccountConfigurationError)
        }
    }

    func test_initialize_failure_cardPaymentValidation() {
        // When
        PSCardForm.createSUT(
            getPaymentMethodShouldSucceedCardPaymentValidation: false,
            getPaymentMethodShouldFailCardPaymentValidation: true
        ) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected a failed PSCardForm result.")
            }
            // Then
            XCTAssertEqual(error.errorCode, .coreInvalidAccountId)
        }
    }

    func test_onCardFormUpdate() {
        // Given
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            var validationStates: [Bool] = []
            sut.onCardFormUpdate = { isValid in
                validationStates.append(isValid)
            }
            self.sut = sut

            // When
            sut.populateFields()

            // Then
            XCTAssertEqual(validationStates.count, 4)
            XCTAssertFalse(validationStates[0])
            XCTAssertFalse(validationStates[1])
            XCTAssertFalse(validationStates[2])
            XCTAssertTrue(validationStates[3])
        }
    }

    func test_onCardBrandRecognition() {
        // Given
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            var cardBrands: [PSCardBrand] = []
            sut.onCardBrandRecognition = { cardBrand in
                cardBrands.append(cardBrand)
            }
            self.sut = sut

            // When
            PSCardBrand.allCases.forEach { cardBrand in
                sut.cardNumberView?.psDelegate?.didUpdateCardBrand(with: cardBrand)
            }

            // Then
            XCTAssertEqual(cardBrands.count, PSCardBrand.allCases.count)
            PSCardBrand.allCases.enumerated().forEach { index, element in
                XCTAssertEqual(cardBrands[index], element)
            }
        }
    }

    func test_tokenize_noAvailableCardData() {
        // Given
        let expectation = expectation(description: "Tokenize fails due to unavailable card data.")
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            guard let mockAPIClient = sut.psAPIClient as? PSAPIClientMock else {
                return XCTFail("PSAPIClient couldn't be casted to PSAPIClientMock.")
            }
            mockAPIClient.tokenizeShouldFail = true
            let options = PSTokenizeOptions.createMock()
            self.sut = sut

            // When
            sut.tokenize(using: options) { tokenizeResult in
                guard case let .failure(error) = tokenizeResult else {
                    return XCTFail("Expected a failed tokenize response.")
                }
                // Then
                XCTAssertEqual(error.errorCode, .invalidCardFields)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_success() {
        // Given
        let expectation = expectation(description: "Tokenize success.")
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            let options = PSTokenizeOptions.createMock()
            sut.populateFields()
            sut.cardNumberView?.cardNumberTextField.cardBrand = .visa
            self.sut = sut

            // When
            sut.tokenize(using: options) { tokenizeResult in
                guard case let .success(paymentHandleToken) = tokenizeResult else {
                    return XCTFail("Expected a successful tokenize response.")
                }
                // Then
                XCTAssertFalse(paymentHandleToken.isEmpty)
                XCTAssertEqual(paymentHandleToken.count, 16)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_failure_unsupportedNetwork() {
        // Given
        let expectation = expectation(description: "Tokenize fails due to unsupported network.")
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            let options = PSTokenizeOptions.createMock()
            sut.populateFields()
            sut.cardNumberView?.cardNumberTextField.cardBrand = .unknown
            self.sut = sut

            // When
            sut.tokenize(using: options) { tokenizeResult in
                guard case let .failure(error) = tokenizeResult else {
                    return XCTFail("Expected a failed tokenize response.")
                }
                // Then
                XCTAssertEqual(error.errorCode, .unsuportedCardBrand)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_failure_invalidMerchantConfiguration() {
        // Given
        let expectation = expectation(description: "Tokenize fails due to invalid merchant configuration.")
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            guard let mockAPIClient = sut.psAPIClient as? PSAPIClientMock else {
                return XCTFail("PSAPIClient couln't be casted to PSAPIClientMock.")
            }
            mockAPIClient.tokenizeShouldFail = true
            let options = PSTokenizeOptions.createMock()
            sut.populateFields()
            self.sut = sut

            // When
            sut.tokenize(using: options) { tokenizeResult in
                guard case let .failure(error) = tokenizeResult else {
                    return XCTFail("Expected a failed tokenize response.")
                }
                // Then
                XCTAssertEqual(error.errorCode, .unsuportedCardBrand)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_reset_fields() {
        // Given
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            sut.populateFields()
            self.sut = sut

            XCTAssertEqual(sut.cardNumberView?.isEmpty(), false)
            XCTAssertEqual(sut.cardholderNameView?.isEmpty(), false)
            XCTAssertEqual(sut.cardExpiryView?.isEmpty(), false)
            XCTAssertEqual(sut.cardCVVView?.isEmpty(), false)

            // When
            sut.resetFields()

            // Then
            XCTAssertEqual(sut.cardNumberView?.isEmpty(), true)
            XCTAssertEqual(sut.cardholderNameView?.isEmpty(), true)
            XCTAssertEqual(sut.cardExpiryView?.isEmpty(), true)
            XCTAssertEqual(sut.cardCVVView?.isEmpty(), true)
        }
    }

    func test_areAllFieldsValid_success() {
        // Given
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            sut.populateFields()
            self.sut = sut

            // When
            let areAllFieldsValid = sut.areAllFieldsValid()

            // Then
            XCTAssertTrue(areAllFieldsValid)
        }
    }

    func test_areAllFieldsValid_failed() {
        // Given
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            self.sut = sut

            // When
            let areAllFieldsValid = sut.areAllFieldsValid()

            // Then
            XCTAssertFalse(areAllFieldsValid)
        }
    }

    func test_PSCardBrand_getCardBrand_newCardFlow() {
        // Given
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            sut.cardNumberView?.cardNumberTextField.cardBrand = .visa
            self.sut = sut

            // When
            let cardBrand = sut.getCardBrand()

            // Then
            XCTAssertEqual(cardBrand, .visa)
        }
    }
}

private extension PSCardForm {
    enum Configuration {
        case UIKit
        case SwiftUI
    }

    static func createSUT(
        configuration: Configuration = .UIKit,
        currencyCodeValidationShouldFail: Bool = false,
        accountIdValidationShouldFail: Bool = false,
        getPaymentMethodShouldFail: Bool = false,
        getPaymentMethodShouldSucceedCardPaymentValidation: Bool = true,
        getPaymentMethodShouldFailCardPaymentValidation: Bool = false,
        completion: @escaping PSCardFormInitializeBlock
    ) {
        let mockAPIClient = PSAPIClientMock(
            apiKey: "apiKey",
            environment: .test
        )
        mockAPIClient.getPaymentMethodShouldFail = getPaymentMethodShouldFail
        mockAPIClient.getPaymentMethodShouldSucceedCardPaymentValidation = getPaymentMethodShouldSucceedCardPaymentValidation
        mockAPIClient.getPaymentMethodShouldFailCardPaymentValidation = getPaymentMethodShouldFailCardPaymentValidation
        PaysafeSDK.shared.psAPIClient = mockAPIClient

        let currencyCode = !currencyCodeValidationShouldFail ? "USD" : "INVALID"
        let accountId = !accountIdValidationShouldFail ? "1001456390" : "INVALID"

        switch configuration {
        case .UIKit:
            PSCardForm.initialize(
                currencyCode: currencyCode,
                accountId: accountId,
                cardNumberView: PSCardNumberInputView(),
                cardholderNameView: PSCardholderNameInputView(),
                cardExpiryView: PSCardExpiryInputView(),
                cardCVVView: PSCardCVVInputView()
            ) { result in
                switch result {
                case let .success(cardForm):
                    completion(.success(cardForm))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        case .SwiftUI:
            PSCardForm.initialize(
                currencyCode: currencyCode,
                accountId: accountId,
                cardNumberSwiftUIView: PSCardNumberInputSwiftUIView(),
                cardholderNameSwiftUIView: PSCardholderNameInputSwiftUIView(),
                cardExpirySwiftUIView: PSCardExpiryInputSwiftUIView(),
                cardCVVSwiftUIView: PSCardCVVInputSwiftUIView()
            ) { result in
                switch result {
                case let .success(cardForm):
                    cardForm.psAPIClient = PSAPIClientMock(
                        apiKey: "apiKey",
                        environment: .test
                    )
                    completion(.success(cardForm))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func populateFields() {
        // Card number
        cardNumberView?.cardNumberTextField.text = "4242424242424242"
        cardNumberView?.cardNumberTextField.textDidChange()

        // Cardholder name
        cardholderNameView?.cardholderNameTextField.text = "John Doe"
        cardholderNameView?.cardholderNameTextField.textDidChange()

        // Card expiry
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let validMonth = String(format: "%02d", currentMonth)
        let validYear = String(currentYear).suffix(2)
        cardExpiryView?.cardExpiryTextField.text = "\(validMonth) / \(validYear)"
        cardExpiryView?.cardExpiryTextField.textDidChange()

        // Card CVV
        cardCVVView?.cardCVVTextField.text = "123"
        cardCVVView?.cardCVVTextField.textDidChange()
    }
}

private extension PSTokenizeOptions {
    static func createMock() -> PSTokenizeOptions {
        PSTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
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
                    phone: "0777777777777",
                    nickName: nil
                ),
                profile: nil
            ),
            accountId: "1001456390",
            threeDS: ThreeDS(merchantUrl: "https://api.qa.paysafe.com/checkout/v2/index.html#/desktop")
        )
    }
}
