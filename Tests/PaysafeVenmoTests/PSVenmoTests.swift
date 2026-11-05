//
//  PSVenmoTests.swift
//
//
//  Created by Eduardo Oliveros on 6/23/24.
//

import Combine
@testable import PaysafeVenmo
@testable import PaysafeCommon
@testable import BraintreeVenmo
import BraintreeCore
import XCTest

final class PSVenmoTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func test_configureClient_success_clientToken() {
        // Given
        let sut = PSVenmo()
        let universalLink = URL(string: "https://paysafe.com/venmo")!
        
        //When
        sut.configureClient(clientToken: "development_tokenization_key", universalLink: universalLink)
        
        // Then
        XCTAssertNotNil(sut.apiClient, "ApiClient should not be nil")
        XCTAssertNotNil(sut.venmoClient, "venmoClient should not be nil")
    }
    
    func test_configureClient_fail_clientToken() {
        // Given
        let sut = PSVenmo()
        let universalLink = URL(string: "https://paysafe.com/venmo")!
        
        //When
        sut.configureClient(clientToken: "", universalLink: universalLink)
        
        // Then
        XCTAssertNil(sut.apiClient, "ApiClient should be nil")
        XCTAssertNil(sut.venmoClient, "venmoClient should be nil")
    }

    func test_configureClient_success_setsDataCollector() {
        // Given
        let sut = PSVenmo()
        let universalLink = URL(string: "https://paysafe.com/venmo")!

        // When
        sut.configureClient(clientToken: "development_tokenization_key", universalLink: universalLink)

        // Then
        XCTAssertNotNil(sut.dataCollector, "dataCollector should not be nil after a successful configuration")
    }

    func test_configureClient_fail_doesNotSetDataCollector() {
        // Given
        let sut = PSVenmo()
        let universalLink = URL(string: "https://paysafe.com/venmo")!

        // When
        sut.configureClient(clientToken: "", universalLink: universalLink)

        // Then
        XCTAssertNil(sut.dataCollector, "dataCollector should remain nil when configuration fails")
    }

    func test_collectDeviceData_withoutConfiguredClient_returnsEmptyString() {
        // Given
        let sut = PSVenmo()
        let expectation = expectation(description: "Collect device data without a configured client.")
        var receivedDeviceData: String?

        // When
        sut.collectDeviceData(clientMetadataId: "metadata-id")
            .sink { deviceData in
                receivedDeviceData = deviceData
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedDeviceData, "", "collectDeviceData should resolve to an empty string when no dataCollector is configured")
    }

    func test_collectDeviceData_withConfiguredClient_completesWithValue() {
        // Given
        let sut = PSVenmo()
        let universalLink = URL(string: "https://paysafe.com/venmo")!
        sut.configureClient(clientToken: "development_tokenization_key", universalLink: universalLink)
        let expectation = expectation(description: "Collect device data with a configured client.")
        var receivedDeviceData: String?

        // When
        sut.collectDeviceData(clientMetadataId: nil)
            .sink { deviceData in
                receivedDeviceData = deviceData
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedDeviceData, "collectDeviceData should always complete with a (possibly empty) String value")
    }
    
    func test_initiateVenmoFlow_failing_tokenizeVenmoAccount() {
        // Given
        let sut = PSVenmo()
        let expectation = expectation(description: "Initiate Venmo flow expectation.")
        let universalLink = URL(string: "https://paysafe.com/venmo")!
        
        //When
        
        sut.configureClient(clientToken: "development_tokenization_key", universalLink: universalLink)
        sut.tokenizeVenmoAccount(profileId: "20", amount: "30")
            .sink { completion in
                XCTFail("tokenizeVenmoAccount should receive failed Value")
                expectation.fulfill()
            } receiveValue: { result in
                // Then
                switch result {
                case .failed:
                    XCTFail("tokenizeVenmoAccount should receive cancel Value")
                case .success(_):
                    XCTFail("tokenizeVenmoAccount should receive cancel Value")
                case .cancel:
                    XCTAssertNotNil(result)
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }

    func test_tokenizeVenmoAccount_errorFromTokenizeCallback_sendsCancel() {
        // Given
        let sut = PSVenmo()
        let expectation = expectation(description: "Tokenize callback error maps to cancel.")
        var receivedResult: PSVenmoBraintreeResult?

        sut.tokenizeVenmoAccount(profileId: "profile", amount: "10.00")
            .sink { _ in
                XCTFail("Publisher should not complete with an error.")
            } receiveValue: { result in
                receivedResult = result
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.handleTokenizeResult(venmoAccount: nil, error: PSError.venmoFailedAuthorization(nil))

        // Then
        wait(for: [expectation], timeout: 1.0)
        guard case .cancel = receivedResult else {
            return XCTFail("Expected .cancel when Braintree tokenize completes with an error.")
        }
    }

    func test_handleTokenizeResult_nilAccount_sendsFailed() {
        // Given
        let sut = PSVenmo()
        let expectation = expectation(description: "Nil Venmo account maps to failed.")
        var receivedResult: PSVenmoBraintreeResult?

        sut.tokenizeVenmoAccount(profileId: "profile", amount: "10.00")
            .sink { _ in
                XCTFail("Publisher should not complete with an error.")
            } receiveValue: { result in
                receivedResult = result
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.handleTokenizeResult(venmoAccount: nil, error: nil)

        // Then
        wait(for: [expectation], timeout: 1.0)
        guard case .failed = receivedResult else {
            return XCTFail("Expected .failed when Braintree returns no Venmo account.")
        }
    }

    func test_handleTokenizeResult_success_mapsVenmoAccountFields() {
        // Given
        let sut = PSVenmo()
        let expectation = expectation(description: "Successful Venmo account mapping.")
        let source = BTVenmoAccountNonce(with: "nonce",
                                         username: "username",
                                         isDefault: true,
                                         externalID: "external-id")
        source.email = "venmo@example.com"
        source.firstName = "John"
        source.lastName = "Doe"
        source.phoneNumber = "+15551234567"
        var receivedAccount: VenmoAccount?

        sut.tokenizeVenmoAccount(profileId: "profile", amount: "10.00")
            .sink { _ in
                XCTFail("Publisher should not complete with an error.")
            } receiveValue: { result in
                if case let .success(venmoAccount) = result {
                    receivedAccount = venmoAccount
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.handleTokenizeResult(venmoAccount: source, error: nil)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedAccount?.email, source.email)
        XCTAssertEqual(receivedAccount?.externalID, source.externalID)
        XCTAssertEqual(receivedAccount?.firstName, source.firstName)
        XCTAssertEqual(receivedAccount?.lastName, source.lastName)
        XCTAssertEqual(receivedAccount?.phoneNumber, source.phoneNumber)
        XCTAssertEqual(receivedAccount?.username, source.username)
        XCTAssertEqual(receivedAccount?.nonce, source.nonce)
        XCTAssertEqual(receivedAccount?.type, source.type)
        XCTAssertEqual(receivedAccount?.isDefault, source.isDefault)
    }

    func test_venmoCanceledRequest() {
        // Given
        let expectation = expectation(description: "Call Venmo canceled Request.")
        let client = PSAPIClient(
            apiKey: "am9objpkb2UK",
            environment: .test
        )
        
        // When
        client.venmoCanceledRequest(jwtToken: "token", deviceData: "{\"correlation_id\": \"123-123-123\"}")
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected failure but received success")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error.errorCode, .venmoFailedAuthorization)
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Expected failure but received success")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
