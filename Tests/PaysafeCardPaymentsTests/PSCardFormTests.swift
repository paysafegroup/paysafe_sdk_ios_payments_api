//
//  PSCardFormTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCommon
@testable import PaysafeCardPayments
@testable import CommonMocks

import XCTest

final class PSCardFormTests: XCTestCase {
    var sut: PSCardForm!
    var mockSession: URLSessionMock!
    var mockNetworkingService: PSNetworkingService!
    var mockAPIClient: PSAPIClientMock!
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        mockNetworkingService = nil
        mockAPIClient = nil
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
            let options = PSCardTokenizeOptions.createMockNative()
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

    func test_tokenize_success() throws {
        // Given
        let expectation = expectation(description: "Tokenize success.")
        
        let paymentHandleId = "test_id1234"
        let apiKey = "am9objpkb2UK"
        let env: PaysafeEnvironment = .test
        guard let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // Set and stub session
        mockSession = URLSessionMock()
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        
        // Set networking service
        mockNetworkingService = PSNetworkingService(
            session: self.mockSession,
            authorizationKey: "testing-auth-key",
            correlationId: "123-123-123",
            sdkVersion: "1.0.0"
        )
        
        // Set api client
        mockAPIClient = PSAPIClientMock(
            apiKey: apiKey,
            environment: env
        )
        mockAPIClient.paymentHandleId = paymentHandleId
        self.mockAPIClient.networkingService = self.mockNetworkingService
        
        // Create SUT
        PSCardForm.createSUT(mockAPIClient: mockAPIClient){ result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            let options = PSCardTokenizeOptions.createMockHtml()
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
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_tokenize_success_with_3DS() throws {
        // Given
        let expectation = expectation(description: "Tokenize success.")
        
        let paymentHandleId = "test_id1234"
        let apiKey = "am9objpkb2UK"
        let env: PaysafeEnvironment = .test
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .completed).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // Set and stub session
        mockSession = URLSessionMock()
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)
        
        // Set networking service
        mockNetworkingService = PSNetworkingService(
            session: self.mockSession,
            authorizationKey: "testing-auth-key",
            correlationId: "123-123-123",
            sdkVersion: "1.0.0"
        )
        
        // Set api client
        mockAPIClient = PSAPIClientMock(
            apiKey: apiKey,
            environment: env
        )
        mockAPIClient.paymentHandleId = paymentHandleId
        mockAPIClient.expectedTokenizeResultStatus = .initiated
        self.mockAPIClient.networkingService = self.mockNetworkingService
        
        // Create SUT
        PSCardForm.createSUT(mockAPIClient: mockAPIClient){ result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            let options = PSCardTokenizeOptions.createMockHtml()
            sut.populateFields()
            sut.cardNumberView?.cardNumberTextField.cardBrand = .visa
            self.sut = sut

            sut.paysafe3DS = Paysafe3DSMock(apiKey: apiKey, environment: env.to3DSEnvironment())
            
            // When
            sut.tokenize(using: options) { tokenizeResult in
                guard case let .success(paymentHandleToken) = tokenizeResult else {
                    return XCTFail("Expected a successful tokenize response.")
                }
                // Then
                XCTAssertFalse(paymentHandleToken.isEmpty)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_tokenize_failure_status_expired() throws {
        // Given
        let expectation = expectation(description: "Tokenize success.")
        
        let paymentHandleId = "test_id1234"
        let apiKey = "am9objpkb2UK"
        let env: PaysafeEnvironment = .test
        guard let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // Set and stub session
        mockSession = URLSessionMock()
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        
        // Set networking service
        mockNetworkingService = PSNetworkingService(
            session: self.mockSession,
            authorizationKey: "testing-auth-key",
            correlationId: "123-123-123",
            sdkVersion: "1.0.0"
        )
        
        // Set api client
        mockAPIClient = PSAPIClientMock(
            apiKey: apiKey,
            environment: env
        )
        mockAPIClient.paymentHandleId = paymentHandleId
        mockAPIClient.expectedTokenizeResultStatus = .failed
        self.mockAPIClient.networkingService = self.mockNetworkingService
        
        // Create SUT
        PSCardForm.createSUT(mockAPIClient: mockAPIClient){ result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            let options = PSCardTokenizeOptions.createMockHtml()
            sut.populateFields()
            sut.cardNumberView?.cardNumberTextField.cardBrand = .visa
            self.sut = sut
            
            // When
            sut.tokenize(using: options) { tokenizeResult in
                guard case let .failure(error) = tokenizeResult else {
                    return XCTFail("Expected a successful tokenize response.")
                }
                // Then
                XCTAssertEqual(error.errorCode, .corePaymentHandleCreationFailed)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_tokenize_failure_unsupportedNetwork() {
        // Given
        let expectation = expectation(description: "Tokenize fails due to unsupported network.")
        PSCardForm.createSUT { result in
            guard case let .success(sut) = result else {
                return XCTFail("Expected a success cardForm result.")
            }
            let options = PSCardTokenizeOptions.createMockBoth()
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
            let options = PSCardTokenizeOptions.createMockNative()
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
            sut.resetCardDetails()

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

fileprivate extension PSCardForm {
    enum Configuration {
        case UIKit
        case SwiftUI
    }

    static func createSUT(
        mockAPIClient: PSAPIClientMock = PSAPIClientMock(
            apiKey: "am9objpkb2UK",
            environment: .test
        ),
        configuration: Configuration = .UIKit,
        currencyCodeValidationShouldFail: Bool = false,
        accountIdValidationShouldFail: Bool = false,
        getPaymentMethodShouldFail: Bool = false,
        getPaymentMethodShouldSucceedCardPaymentValidation: Bool = true,
        getPaymentMethodShouldFailCardPaymentValidation: Bool = false,
        completion: @escaping PSCardFormInitializeBlock
    ) {
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
                        apiKey: "am9objpkb2UK",
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

private extension PSCardTokenizeOptions {
    static func createMockNative() -> PSCardTokenizeOptions {
        PSCardTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            accountId: "1001456390",
            threeDS: ThreeDS(merchantUrl: "https://api.qa.paysafe.com/checkout/v2/index.html#/desktop"), renderType: .html
        )
    }
    
    static func createMockHtml() -> PSCardTokenizeOptions {
        PSCardTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            accountId: "1001456390",
            threeDS: ThreeDS(merchantUrl: "https://api.qa.paysafe.com/checkout/v2/index.html#/desktop"), renderType: .html
        )
    }
    
    static func createMockBoth() -> PSCardTokenizeOptions {
        PSCardTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            accountId: "1001456390",
            threeDS: ThreeDS(merchantUrl: "https://api.qa.paysafe.com/checkout/v2/index.html#/desktop"), renderType: .both
        )
    }
}
