//
//  PSVenmoContextTests.swift
//  
//
//  Created by Calin Ciubotariu on 14.06.2024.
//

@testable import PaysafeCommon
@testable import PaysafeVenmo
@testable import CommonMocks

import XCTest
import Combine
import Foundation
import BraintreeCore

final class PSVenmoContextIntegrationTests: XCTestCase {
    var mockSession: URLSessionMock!
    var mockNetworkingService: PSNetworkingService!
    var apiClient: PSAPIClient!

    override func setUpWithError() throws {
        mockSession = URLSessionMock()
        PSVenmoContext.configureAppSwitchReturn(
            universalLink: "https://merchant.example.com/venmo",
            returnURLScheme: "com.example.app.payments"
        )
    }

    override func tearDownWithError() throws {
        mockSession = URLSessionMock()
        PSVenmoContext.universalLink = nil
        PSVenmoContext.returnURLScheme = ""
    }
    
    func test_successfull_initialize() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        setupNetworkServiceAndAPIClient()
        
        // When
        let sut = makeInitializedVenmoContext()
        
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut!.psVenmo)
    }
    
    func test_initialize_failure_badCurrencyCode() throws {
        // Given
        let expectation = expectation(description: "Initiate PSVenmoContext expectation.")
        try setupNetworkLayerForSuccessfulContextInitialization()
        setupNetworkServiceAndAPIClient()
        
        // When
        var sut: PSVenmoContext?
        PSVenmoContext.initialize(
            currencyCode: "USDDD",
            accountId: "acc789") { result in
                switch result {
                case .success(let successfulContext):
                    sut = successfulContext
                    XCTFail("Expected failure, received success.")
                case .failure(let receivedError):
                    // Then
                    let expectedError = PSError.coreInvalidCurrencyCode(PaysafeSDK.shared.correlationId)
                    XCTAssertEqual(receivedError.errorCode, expectedError.errorCode)
                    XCTAssertEqual(receivedError.code, expectedError.code)
                    XCTAssertEqual(receivedError.detailedMessage, expectedError.detailedMessage)
                    expectation.fulfill()
                }
            }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(sut)
    }
    
    func test_initialize_failure_getPaymentMethods_badRequest() throws {
        // Given
        let expectation = expectation(description: "Initiate PSVenmoContext expectation.")
        try setupNetworkLayerForFailedContextInitialization_badRequest()
        setupNetworkServiceAndAPIClient()
        
        // When
        var sut: PSVenmoContext?
        PSVenmoContext.initialize(
            currencyCode: "USD",
            accountId: "acc78910") { result in
                switch result {
                case .success(let successfulContext):
                    sut = successfulContext
                    XCTFail("Expected failure, received success.")
                case .failure(let receivedError):
                    // Then
                    let expectedError = PSError.coreFailedToFetchAvailablePayments(PaysafeSDK.shared.correlationId)
                    XCTAssertEqual(receivedError.errorCode, expectedError.errorCode)
                    XCTAssertEqual(receivedError.code, expectedError.code)
                    XCTAssertEqual(receivedError.detailedMessage, expectedError.detailedMessage)
                    expectation.fulfill()
                }
            }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(sut)
    }
    
    func test_initialize_failure_getPaymentMethods_methodNotSupported() throws {
        // Given
        let expectation = expectation(description: "Initiate PSVenmoContext expectation.")
        try setupNetworkLayerForFailedContextInitialization_methodNotSupported()
        setupNetworkServiceAndAPIClient()
        
        // When
        var sut: PSVenmoContext?
        PSVenmoContext.initialize(
            currencyCode: "USD",
            accountId: "acc789") { result in
                switch result {
                case .success(let successfulContext):
                    sut = successfulContext
                    XCTFail("Expected failure, received success.")
                case .failure(let receivedError):
                    // Then
                    let expectedError = PSError.coreInvalidAccountId(
                        PaysafeSDK.shared.correlationId, 
                        message: "Invalid account id for unknown."
                    )
                    XCTAssertEqual(receivedError.errorCode, expectedError.errorCode)
                    XCTAssertEqual(receivedError.code, expectedError.code)
                    XCTAssertEqual(receivedError.detailedMessage, expectedError.detailedMessage)
                    expectation.fulfill()
                }
            }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(sut)
    }
    
    func test_successfull_tokenize_newUser() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        sut?.tokenize(
            using: tokenizeOptions,
            completion: { result in
                switch result {
                case .success(let paymentHandleToken):
                    // Then
                    XCTAssertNotNil(paymentHandleToken)
                case .failure(_):
                    XCTFail("Expected success, received failure.")
                }
            }
        )
    }
    
    func test_successfull_tokenize_returningUser_legacyFlow() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization_payableStatus()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        sut?.tokenize(
            using: tokenizeOptions,
            completion: { result in
                switch result {
                case .success(let paymentHandleToken):
                    // Then
                    XCTAssertNotNil(paymentHandleToken)
                case .failure(_):
                    XCTFail("Expected success, received failure.")
                }
            }
        )
    }

    func test_tokenize_returningUser_braintreeDetailsUpdateReturnsFalse() throws {
        // Given
        let tokenizeExpectation = expectation(description: "Tokenize existing Venmo customer when braintree details returns false.")
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForFailedTokenization_existingBraintreeCustomer_braintreeDetailsFalse()
        setupNetworkServiceAndAPIClient()

        let sut = makeInitializedVenmoContext()

        // When
        let internalVenmoMock = PSVenmoMock()
        sut?.psVenmo = internalVenmoMock
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        sut?.tokenize(
            using: tokenizeOptions,
            completion: { result in
                switch result {
                case .success(let paymentHandleToken):
                    // Then
                    XCTAssertNotNil(paymentHandleToken)
                    XCTAssertEqual(internalVenmoMock.collectDeviceDataClientMetadataIdPassed, "metadata-id")
                    tokenizeExpectation.fulfill()
                case .failure:
                    XCTFail("Expected success, received failure.")
                }
            }
        )

        wait(for: [tokenizeExpectation], timeout: 1.0)
    }

    func test_successfull_tokenize_returningUser_collectData() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization_existingBraintreeCustomer()
        setupNetworkServiceAndAPIClient()

        let sut = makeInitializedVenmoContext()

        // When
        let internalVenmoMock = PSVenmoMock()
        sut?.psVenmo = internalVenmoMock
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        sut?.tokenize(
            using: tokenizeOptions,
            completion: { result in
                switch result {
                case .success(let paymentHandleToken):
                    // Then
                    XCTAssertNotNil(paymentHandleToken)
                    XCTAssertEqual(internalVenmoMock.collectDeviceDataClientMetadataIdPassed, "metadata-id")
                case .failure:
                    XCTFail("Expected success, received failure.")
                }
            }
        )
    }

    func test_tokenizeOptions_correctly_passedTo_venmo() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        let internalVenmoMock = PSVenmoMock()
        sut?.psVenmo = internalVenmoMock
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789", amount: 1234)
        sut?.tokenize(
            using: tokenizeOptions,
            completion: { result in
                switch result {
                case .success(_):
                    // Then
                    XCTAssertEqual(internalVenmoMock.profileIdPassed, tokenizeOptions.venmo?.profileId)
                    XCTAssertEqual(internalVenmoMock.amountPassed, "12.34")
                case .failure(_):
                    XCTFail("Expected success, received failure.")
                }
            }
        )
    }
    
    func test_failed_tokenize_invalidAmount() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789", amount: 0)
        tokenizeExpectingFailure(
            sut,
            using: tokenizeOptions,
            expectedError: PSError.invalidAmount(PaysafeSDK.shared.correlationId)
        )
    }
    
    func test_failed_tokenize_invalidEmail() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789", email: "a@b.c")
        let receivedError: PSError? = sut?.validateTokenizeOptions(tokenizeOptions)
        
        let expectedError = PSError.invalidEmail(PaysafeSDK.shared.correlationId)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError!.errorCode, expectedError.errorCode)
        XCTAssertEqual(receivedError!.code, expectedError.code)
        XCTAssertEqual(receivedError!.detailedMessage, expectedError.detailedMessage)
    }
    
    func test_failed_tokenize_invalidFirstName() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789", firstName: "")
        let receivedError: PSError? = sut?.validateTokenizeOptions(tokenizeOptions)
        
        let expectedError = PSError.invalidFirstName(PaysafeSDK.shared.correlationId)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError!.errorCode, expectedError.errorCode)
        XCTAssertEqual(receivedError!.code, expectedError.code)
        XCTAssertEqual(receivedError!.detailedMessage, expectedError.detailedMessage)
    }
    
    func test_failed_tokenize_invalidLastName() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789", lastName: "")
        let receivedError: PSError? = sut?.validateTokenizeOptions(tokenizeOptions)
        
        let expectedError = PSError.invalidLastName(PaysafeSDK.shared.correlationId)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError!.errorCode, expectedError.errorCode)
        XCTAssertEqual(receivedError!.code, expectedError.code)
        XCTAssertEqual(receivedError!.detailedMessage, expectedError.detailedMessage)
    }
    
    func test_failed_tokenize_token_with_failedStatus() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForFailedTokenization_failedStatus()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        tokenizeExpectingFailure(
            sut,
            using: tokenizeOptions,
            expectedError: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)
        )
    }

    func test_failed_tokenize_token_with__expiredStatus() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization_noBraintreeTokens(status: "EXPIRED")
        setupNetworkServiceAndAPIClient()

        let sut = makeInitializedVenmoContext()

        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        tokenizeExpectingFailure(
            sut,
            using: tokenizeOptions,
            expectedError: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)
        )
    }

    func test_failed_tokenize_noBraintreeTokens() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization_noBraintreeTokens()
        setupNetworkServiceAndAPIClient()
        
        let sut = makeInitializedVenmoContext()
        
        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        tokenizeExpectingFailure(
            sut,
            using: tokenizeOptions,
            expectedError: PSError.genericAPIError(PaysafeSDK.shared.correlationId)
        )
    }

    func test_failed_tokenize_invalidUniversalLink() throws {
        // Given
        PSVenmoContext.configureAppSwitchReturn(
            universalLink: "",
            returnURLScheme: "com.example.app.payments"
        )
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()

        let sut = makeInitializedVenmoContext()

        // When
        sut?.psVenmo = PSVenmoMock()
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        tokenizeExpectingFailure(
            sut,
            using: tokenizeOptions,
            expectedError: PSError.venmoInvalidUniversalLinkPassed(PaysafeSDK.shared.correlationId)
        )
    }

    func test_failed_tokenize_when_venmoFailed() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()

        let sut = makeInitializedVenmoContext()

        // When
        let internalVenmoMock = PSVenmoMock()
        internalVenmoMock.initiateVenmoFlowResult = .failed
        sut?.psVenmo = internalVenmoMock
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        tokenizeExpectingFailure(
            sut,
            using: tokenizeOptions,
            expectedError: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)
        )
    }

    func test_failed_tokenize_when_venmoCanceled() throws {
        // Given
        try setupNetworkLayerForSuccessfulContextInitialization()
        try setupNetworkLayerForSuccessfulTokenization()
        setupNetworkServiceAndAPIClient()

        let sut = makeInitializedVenmoContext()

        // When
        let internalVenmoMock = PSVenmoMock()
        internalVenmoMock.initiateVenmoFlowResult = .cancel
        sut?.psVenmo = internalVenmoMock
        let tokenizeOptions = PSCardTokenizeOptions.mockForVenmo(accountId: "acc789")
        tokenizeExpectingFailure(
            sut,
            using: tokenizeOptions,
            expectedError: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)
        )
    }

    func test_PSVenmoContext_configureAppSwitchReturn() {
        // Given
        let universalLinkString = "https://merchant.example.com/venmo"
        let returnURLScheme = "com.example.app.payments"
        PSVenmoContext.configureAppSwitchReturn(
            universalLink: universalLinkString,
            returnURLScheme: returnURLScheme
        )
        guard let matchingURL = URL(string: "\(returnURLScheme)://braintree-payments") else {
            return XCTFail("Expected a valid matching URL.")
        }
        guard let nonMatchingURL = URL(string: "https://other-domain.com/venmo") else {
            return XCTFail("Expected a valid non-matching URL.")
        }

        // Then
        XCTAssertEqual(PSVenmoContext.universalLink, URL(string: universalLinkString))
        XCTAssertEqual(PSVenmoContext.returnURLScheme, returnURLScheme)
        XCTAssertTrue(PSVenmoContext.canOpenURL(url: matchingURL))
        XCTAssertFalse(PSVenmoContext.canOpenURL(url: nonMatchingURL))
        PSVenmoContext.openURL(url: matchingURL)
    }
}

private extension PSVenmoContextIntegrationTests {
    private func makeInitializedVenmoContext(
        currencyCode: String = "USD",
        accountId: String = "acc789"
    ) -> PSVenmoContext? {
        let initializeExpectation = expectation(description: "Initiate PSVenmoContext expectation.")
        var sut: PSVenmoContext?
        PSVenmoContext.initialize(
            currencyCode: currencyCode,
            accountId: accountId
        ) { result in
            switch result {
            case .success(let successfulContext):
                sut = successfulContext
                initializeExpectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        }
        wait(for: [initializeExpectation], timeout: 1.0)
        return sut
    }

    private func tokenizeExpectingFailure(
        _ sut: PSVenmoContext?,
        using options: PSVenmoTokenizeOptions,
        expectedError: PSError
    ) {
        sut?.tokenize(
            using: options,
            completion: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure, received success.")
                case .failure(let receivedError):
                    XCTAssertEqual(receivedError.errorCode, expectedError.errorCode)
                    XCTAssertEqual(receivedError.code, expectedError.code)
                    XCTAssertEqual(receivedError.detailedMessage, expectedError.detailedMessage)
                }
            }
        )
    }

    private func setupNetworkServiceAndAPIClient() {
        mockNetworkingService = PSNetworkingService(
            session: mockSession,
            authorizationKey: "testing-auth-key",
            correlationId: "123-123-123",
            sdkVersion: "1.0.0"
        )
        apiClient = PSAPIClient(
            apiKey: "testing-api-key",
            environment: .test
        )
        apiClient.networkingService = mockNetworkingService
        PaysafeSDK.shared.psAPIClient = apiClient
    }
    
    private func setupNetworkLayerForSuccessfulTokenization() throws {
        try setupNetworkLayerForSuccessfulPaymentHandleCreation()
        try setupNetwokLayerForSuccessfulBraintreeDetailsRequest()
        try setupNetworkLayerForRefreshTokenPayable()
    }
    
    private func setupNetworkLayerForFailedTokenization_failedStatus() throws {
        try setupNetworkLayerForSuccessfulPaymentHandleCreation_failedStatus()
        try setupNetwokLayerForSuccessfulBraintreeDetailsRequest()
        try setupNetworkLayerForRefreshTokenPayable()
    }
    
    private func setupNetworkLayerForSuccessfulTokenization_payableStatus() throws {
        try setupNetworkLayerForSuccessfulPaymentHandleCreation_payableStatus()
        try setupNetwokLayerForSuccessfulBraintreeDetailsRequest()
        try setupNetworkLayerForRefreshTokenPayable()
    }

    private func setupNetworkLayerForSuccessfulTokenization_noBraintreeTokens(status: String = "INITIATED") throws {
        try setupNetworkLayerForSuccessfulPaymentHandleCreation_noBraintreeTokens(status: status)
        try setupNetwokLayerForSuccessfulBraintreeDetailsRequest()
        try setupNetworkLayerForRefreshTokenPayable()
    }

    private func setupNetworkLayerForSuccessfulTokenization_existingBraintreeCustomer() throws {
        try setupNetworkLayerForSuccessfulPaymentHandleCreation_existingBraintreeCustomer()
        try setupNetwokLayerForSuccessfulBraintreeDetailsRequestNoNonce()
        try setupNetworkLayerForRefreshTokenPayable()
    }

    private func setupNetworkLayerForFailedTokenization_existingBraintreeCustomer_braintreeDetailsFalse() throws {
        try setupNetworkLayerForSuccessfulPaymentHandleCreation_existingBraintreeCustomer()
        try setupNetworkLayerForBraintreeDetailsRequestNoNonceReturningFalse()
        try setupNetworkLayerForRefreshTokenPayable()
    }

    private func setupNetworkLayerForSuccessfulTokenization_existingBraintreeCustomer_noClientToken() throws {
        try setupNetworkLayerForSuccessfulPaymentHandleCreation_existingBraintreeCustomer_noClientToken()
        try setupNetworkLayerForRefreshTokenPayable()
    }
    
    private func setupNetwokLayerForSuccessfulBraintreeDetailsRequest() throws {
        let braintreeDetailsURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/alternatepayments/venmo/v1/hostedSession/braintreeDetails?payment_method_nonce=fake-nonce&payment_method_payerInfo=%7B%22firstName%22:%22%22,%20%22lastName%22:%22%22,%20%22phoneNumber%22:%22%22,%20%22email%22:%20%22%22,%20%22externalId%22:%22%22,%20%22userName%22:%22@%22%7D&payment_method_jwtToken=session-token&payment_method_deviceData=%7B%22correlation_id%22:%20%22123-123-123%22%7D&errorCode=")
        )
        let mockResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: braintreeDetailsURL,
                statusCode: 307,
                httpVersion: nil,
                headerFields: nil
            )
        )
        mockSession.stubRequest(
            url: braintreeDetailsURL,
            data: nil,
            response: mockResponse,
            error: nil
        )
    }

    private func setupNetwokLayerForSuccessfulBraintreeDetailsRequestNoNonce() throws {
        let braintreeDetailsURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/alternatepayments/venmo/v1/hostedSession/braintreeDetails?payment_method_nonce=&payment_method_payerInfo=&payment_method_jwtToken=session-token&payment_method_deviceData=%7B%22correlation_id%22:%20%22123-123-123%22%7D&errorCode=")
        )
        let mockResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: braintreeDetailsURL,
                statusCode: 307,
                httpVersion: nil,
                headerFields: nil
            )
        )
        mockSession.stubRequest(
            url: braintreeDetailsURL,
            data: nil,
            response: mockResponse,
            error: nil
        )
    }

    private func setupNetworkLayerForBraintreeDetailsRequestNoNonceReturningFalse() throws {
        let braintreeDetailsURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/alternatepayments/venmo/v1/hostedSession/braintreeDetails?payment_method_nonce=&payment_method_payerInfo=&payment_method_jwtToken=session-token&payment_method_deviceData=%7B%22correlation_id%22:%20%22123-123-123%22%7D&errorCode=")
        )
        let mockResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: braintreeDetailsURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        mockSession.stubRequest(
            url: braintreeDetailsURL,
            data: Data("false".utf8),
            response: mockResponse,
            error: nil
        )
    }

    private func setupNetworkLayerForSuccessfulContextInitialization() throws {
        let getAvailablePaymentsURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/configuration?currencyCode=USD")
        )
        let mockResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: getAvailablePaymentsURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        let mockData = try XCTUnwrap(
            PaymentMethodsResponse.jsonMockWithVenmo().data(using: .utf8)
        )
        mockSession.stubRequest(
            url: getAvailablePaymentsURL,
            data: mockData,
            response: mockResponse,
            error: nil
        )
    }

    private func setupNetworkLayerForFailedContextInitialization_badRequest() throws {
        let getAvailablePaymentsURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/configuration?currencyCode=USD")
        )
        let mockResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: getAvailablePaymentsURL,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )
        )
        let mockData = try XCTUnwrap(
            PaymentMethodsResponse.jsonMockBadRequest().data(using: .utf8)
        )
        mockSession.stubRequest(
            url: getAvailablePaymentsURL,
            data: mockData,
            response: mockResponse,
            error: nil
        )
    }
    
    private func setupNetworkLayerForFailedContextInitialization_methodNotSupported() throws {
        let getAvailablePaymentsURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/configuration?currencyCode=USD")
        )
        let mockResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: getAvailablePaymentsURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        let mockData = try XCTUnwrap(
            PaymentMethodsResponse.jsonMock().data(using: .utf8)
        )
        mockSession.stubRequest(
            url: getAvailablePaymentsURL,
            data: mockData,
            response: mockResponse,
            error: nil
        )
    }
    
    private func setupNetworkLayerForSuccessfulPaymentHandleCreation() throws {
        let tokenizeURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles")
        )
        let tokenizeMockResponse = HTTPURLResponse(
            url: tokenizeURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let tokenizeMockData = try XCTUnwrap(
            PaymentResponse.jsonMockWithVenmo(paymentHandleToken: "paymentHandleId").data(using: .utf8)
        )
        mockSession.stubRequest(
            url: tokenizeURL,
            data: tokenizeMockData,
            response: tokenizeMockResponse,
            error: nil
        )
    }
    
    private func setupNetworkLayerForSuccessfulPaymentHandleCreation_noBraintreeTokens(status: String = "INITIATED") throws {
        let tokenizeURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles")
        )
        let tokenizeMockResponse = HTTPURLResponse(
            url: tokenizeURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let tokenizeMockData = try XCTUnwrap(
            PaymentResponse.jsonMockWithVenmo_noGatewayResponse(
                paymentHandleToken: "paymentHandleId",
                status: status
            ).data(using: .utf8)
        )
        mockSession.stubRequest(
            url: tokenizeURL,
            data: tokenizeMockData,
            response: tokenizeMockResponse,
            error: nil
        )
    }

    private func setupNetworkLayerForSuccessfulPaymentHandleCreation_existingBraintreeCustomer() throws {
        let tokenizeURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles")
        )
        let tokenizeMockResponse = HTTPURLResponse(
            url: tokenizeURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let tokenizeMockData = try XCTUnwrap(
            PaymentResponse.jsonMockWithVenmo_existingBraintreeCustomer(
                paymentHandleToken: "paymentHandleId"
            ).data(using: .utf8)
        )
        mockSession.stubRequest(
            url: tokenizeURL,
            data: tokenizeMockData,
            response: tokenizeMockResponse,
            error: nil
        )
    }

    private func setupNetworkLayerForSuccessfulPaymentHandleCreation_existingBraintreeCustomer_noClientToken() throws {
        let tokenizeURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles")
        )
        let tokenizeMockResponse = HTTPURLResponse(
            url: tokenizeURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let tokenizeMockData = try XCTUnwrap(
            PaymentResponse.jsonMockWithVenmo_existingBraintreeCustomer_noClientToken(paymentHandleToken: "paymentHandleId").data(using: .utf8)
        )
        mockSession.stubRequest(
            url: tokenizeURL,
            data: tokenizeMockData,
            response: tokenizeMockResponse,
            error: nil
        )
    }
    
    private func setupNetworkLayerForSuccessfulPaymentHandleCreation_failedStatus() throws {
        let tokenizeURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles")
        )
        let tokenizeMockResponse = HTTPURLResponse(
            url: tokenizeURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let tokenizeMockData = try XCTUnwrap(
            PaymentResponse.jsonMockWithVenmo(
                paymentHandleToken: "paymentHandleId",
                status: "FAILED"
            ).data(using: .utf8)
        )
        mockSession.stubRequest(
            url: tokenizeURL,
            data: tokenizeMockData,
            response: tokenizeMockResponse,
            error: nil
        )
    }
    
    private func setupNetworkLayerForSuccessfulPaymentHandleCreation_payableStatus() throws {
        let tokenizeURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles")
        )
        let tokenizeMockResponse = HTTPURLResponse(
            url: tokenizeURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let tokenizeMockData = try XCTUnwrap(
            PaymentResponse.jsonMockWithVenmo(
                paymentHandleToken: "paymentHandleId",
                status: "PAYABLE"
            ).data(using: .utf8)
        )
        mockSession.stubRequest(
            url: tokenizeURL,
            data: tokenizeMockData,
            response: tokenizeMockResponse,
            error: nil
        )
    }
    
    private func setupNetworkLayerForRefreshTokenPayable() throws {
        let searchURL = try XCTUnwrap(
            URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search")
        )
        let mockResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: searchURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        let mockSearchData = try XCTUnwrap(
            RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8)
        )
        mockSession.stubRequest(
            url: searchURL,
            data: mockSearchData,
            response: mockResponse,
            error: nil
        )
    }
}

extension PSCardTokenizeOptions {
    static func mockForVenmo(
        accountId: String,
        amount: Int = 1000,
        email: String = "john.doe@paysafe.com",
        firstName: String = "John",
        lastName: String = "Doe"
    ) -> PSVenmoTokenizeOptions {
        PSVenmoTokenizeOptions(
            amount: amount,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            profile: Profile(
                firstName: "\(firstName)",
                lastName:  "\(lastName)",
                locale: .en_GB,
                merchantCustomerId: "merchantCustomerId",
                dateOfBirth: DateOfBirth(
                    day: 20,
                    month: 6,
                    year: 1991
                ),
                email: "\(email)",
                phone: "319493030030",
                mobile: "32919399439",
                gender: .male,
                nationality: "USA",
                identityDocuments: [.init(
                    documentNumber: "1923929319"
                )]
            ),
            accountId: accountId,
            dupCheck: false,
            merchantDescriptor: MerchantDescriptor(
                dynamicDescriptor: "testMerchantDescriptor",
                phone: "testPhone"
            ),
            shippingDetails: ShippingDetails(
                shipMethod: .nextDay,
                street: "Delivery street",
                street2: "Delivery street 2",
                city: nil,
                state: "Texas",
                country: nil,
                zip: "400234"
            ),
            deviceFingerprinting: DeviceFingerprinting(threatMetrixSessionId: ""),
            venmo: VenmoAdditionalData(
                consumerId: email,
                merchantAccountId: "venmo-merchant-account-id",
                profileId: "venmo-profileId"
            )
        )
    }
}
