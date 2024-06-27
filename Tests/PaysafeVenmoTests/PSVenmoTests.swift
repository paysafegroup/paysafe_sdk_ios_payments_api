//
//  PSVenmoTests.swift
//
//
//  Created by Eduardo Oliveros on 6/23/24.
//

import Combine
@testable import PaysafeVenmo
import PaysafeCommon
import BraintreeCore
import XCTest

final class PSVenmoTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        BTAppContextSwitcher.sharedInstance.returnURLScheme = "Test"
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func test_configureClient_success_clientId() {
        // Given
        let sut = PSVenmo()
        
        //When
        sut.configureClient(clientId: "development_tokenization_key")
        
        // Then
        XCTAssertNotNil(sut.apiClient, "ApiClient should not be nil")
        XCTAssertNotNil(sut.venmoClient, "venmoClient should not be nil")
    }
    
    func test_configureClient_fail_clientId() {
        // Given
        let sut = PSVenmo()
        
        //When
        sut.configureClient(clientId: "")
        
        // Then
        XCTAssertNil(sut.apiClient, "ApiClient should be nil")
        XCTAssertNil(sut.venmoClient, "venmoClient should be nil")
    }
    
    func test_initiateVenmoFlow_failure_venmoAppNotFound() {
        // Given
        let sut = PSVenmo()
        let expectation = expectation(description: "Initiate Venmo flow expectation.")
        
        //When
        sut.initiateVenmoFlow(profileId: "20", amount: 30)
        
        // Then
        
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    let expectedError = PSError.venmoAppNotFound()
                    XCTAssertEqual(error.errorCode, expectedError.errorCode)
                    XCTAssertEqual(error.detailedMessage, expectedError.detailedMessage)
                    XCTAssertEqual(error.displayMessage, expectedError.displayMessage)
                }
                XCTAssertNotNil(completion)
                expectation.fulfill()
            } receiveValue: { result in
                // Then
                XCTAssertNotNil(result)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_initiateVenmoFlow_failing_tokenizeVenmoAccount() {
        // Given
        let sut = PSVenmo()
        let expectation = expectation(description: "Initiate Venmo flow expectation.")
        
        //When
        
        sut.configureClient(clientId: "development_tokenization_key")
        sut.tokenizeVenmoAccount(profileId: "20", amount: 30)
            .sink { completion in
                XCTFail("tokenizeVenmoAccount should receive failed Value")
                expectation.fulfill()
            } receiveValue: { result in
                // Then
                switch result {
                case .failed:
                    XCTAssertNotNil(result)
                case .success(_):
                    XCTFail("tokenizeVenmoAccount should receive failed Value")
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
