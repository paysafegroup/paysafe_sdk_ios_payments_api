//
//  PSAPIClientTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PaysafeCommon
@testable import PaysafeCore
import PaysafeNetworking
import XCTest

final class PSAPIClientTests: XCTestCase {
    var sut: PSAPIClient!
    var mockSession: URLSessionMock!
    var mock3DS: Paysafe3DSMock!
    var mockNetworkingService: PSNetworkingService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockSession = URLSessionMock()
        mock3DS = Paysafe3DSMock(
            apiKey: "am9objpkb2UK",
            environment: .staging
        )
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
        sut.paysafe3DS = mock3DS
        cancellables = []
    }

    override func tearDown() {
        mockSession = nil
        mock3DS = nil
        mockNetworkingService = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
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

    func test_cardTokenize_noThreeDS_failure() throws {
        // Given
        let expectation = expectation(description: "Tokenize method fails without ThreeDS attribute.")
        let expectedError = URLError(URLError.Code.badServerResponse)
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForNewCardPayment(accountId: "139203223")
        let paymentType: PaymentType = .card
        let mockCardRequest = CardRequest.mock()
        let mockData = try XCTUnwrap(PaymentResponse.jsonMock(paymentHandleId: "paymentHandleId").data(using: .utf8))
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let mockResponse = try XCTUnwrap(HTTPURLResponse(url: tokenizeURL, statusCode: 400, httpVersion: nil, headerFields: nil))
        mockSession.stubRequest(url: tokenizeURL, data: mockData, response: mockResponse, error: expectedError)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType,
            card: mockCardRequest
        )
        .sink { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure but received success")
            case let .failure(error):
                // Then
                XCTAssertEqual(error.errorCode, .genericAPIError)
                expectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("Expected failure but received success")
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_newCard_3DS_success_payable() throws {
        // Given
        let expectation = expectation(description: "Tokenize method succeeds with 3DS flow and new card")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForNewCardPayment(accountId: "139203223")
        let paymentType: PaymentType = .card
        let mockCardRequest = CardRequest.mock()
        let paymentHandleId = "test_id1234"
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType,
            card: mockCardRequest
        )
        .sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_newCard_3DS_failure_nonPayable() throws {
        // Given
        let expectation = expectation(description: "Tokenize method fails with non payable status.")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForNewCardPayment(accountId: "139203223")
        let paymentType: PaymentType = .card
        let mockCardRequest = CardRequest.mock()
        let paymentHandleId = "test_id1234"
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .completed).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType,
            card: mockCardRequest
        )
        .sink { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure but received success")
            case let .failure(error):
                // Then
                XCTAssertEqual(error.errorCode, .corePaymentHandleCreationFailed)
                expectation.fulfill()
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_savedCard_3DS_success_payable() throws {
        // Given
        let expectation = expectation(description: "Tokenize method succeeds with 3DS flow and saved card")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForSavedCardPayment(accountId: "139203223")
        let paymentType: PaymentType = .card
        let mockCardRequest = CardRequest.mockSavedCard()
        let paymentHandleId = "test_id1234"
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType,
            card: mockCardRequest
        )
        .sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_savedCard_3DS_withNetworkTokenBin_success() throws {
        // Given
        let expectation = expectation(description: "Tokenize method succeeds with 3DS flow and saved card")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForSavedCardPayment(accountId: "139203223")
        let paymentType: PaymentType = .card
        let mockCardRequest = CardRequest.mockSavedCard()
        let paymentHandleId = "test_id1234"
        let networkToken = NetworkToken(bin: "networkTokenBin")
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(
                  paymentHandleId: paymentHandleId,
                  networkToken: networkToken
              )
              .data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock(with: networkToken)
              .data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType,
            card: mockCardRequest
        )
        .sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_savedCard_3DS_shippingMethodTwoDayService_success_payable() throws {
        // Given
        let expectation = expectation(description: "Tokenize method succeeds with 3DS flow and saved card")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForSavedCardPayment(
            accountId: "139203223",
            shipMethod: .twoDayService
        )
        let paymentType: PaymentType = .card
        let mockCardRequest = CardRequest.mockSavedCard()
        let paymentHandleId = "test_id1234"
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType,
            card: mockCardRequest
        )
        .sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_savedCard_3DS_shippingMethodOther_success_payable() throws {
        // Given
        let expectation = expectation(description: "Tokenize method succeeds with 3DS flow and saved card")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForSavedCardPayment(
            accountId: "139203223",
            shipMethod: .other
        )
        let paymentType: PaymentType = .card
        let mockCardRequest = CardRequest.mockSavedCard()
        let paymentHandleId = "test_id1234"
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType,
            card: mockCardRequest
        )
        .sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_applePay_success() throws {
        // Given
        let expectation = expectation(description: "Tokenize method succeeds for apple pay.")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForApplePay(accountId: "139203223")
        let paymentType: PaymentType = .card
        let paymentHandleId = "test_id1234"
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType
        )
        .sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tokenize_payPal_success() throws {
        // Given
        let expectation = expectation(description: "Tokenize method succeeds for apple pay.")
        let mockTokenizeOptions = PSCardTokenizeOptions.mockForPayPal(accountId: "139203223")
        let paymentType: PaymentType = .card
        let paymentHandleId = "test_id1234"
        guard let mockAuthenticationData = AuthenticationResponse.jsonMock().data(using: .utf8),
              let mockTokenizeData = PaymentResponse.jsonMockWith3DS(paymentHandleId: paymentHandleId).data(using: .utf8),
              let mockFinalizeData = FinalizeResponse.jsonMock().data(using: .utf8),
              let mockSearchData = RefreshPaymentHandleTokenResponse.jsonMock(status: .payable).data(using: .utf8) else {
            return XCTFail("Unable to convert mock JSON to Data")
        }
        mock3DS.stub3DSSucceeds(challengeAuthenticationId: "challengeAuthenticationId")
        let tokenizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles"))
        let authenticationURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications"))
        let finalizeURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/challengeAuthenticationId/finalize"))
        let searchURL = try XCTUnwrap(URL(string: "https://api.test.paysafe.com/paymenthub/v1/singleusepaymenthandles/search"))
        let mockResponse = HTTPURLResponse(url: tokenizeURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.stubRequest(url: tokenizeURL, data: mockTokenizeData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: authenticationURL, data: mockAuthenticationData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: searchURL, data: mockSearchData, response: mockResponse, error: nil)
        mockSession.stubRequest(url: finalizeURL, data: mockFinalizeData, response: mockResponse, error: nil)

        // When
        sut.tokenize(
            options: mockTokenizeOptions,
            paymentType: paymentType
        )
        .sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { paymentHandleResponse in
            // Then
            XCTAssertEqual(paymentHandleResponse.accountId, mockTokenizeOptions.accountId)
            XCTAssertFalse(paymentHandleResponse.paymentHandleToken.isEmpty)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
