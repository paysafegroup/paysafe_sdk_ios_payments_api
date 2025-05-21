//
//  SimulatorTests.swift
//
//
//  Created by Eduardo Oliveros on 7/30/24.
//

@testable import PaysafeCommon
import XCTest
import Combine

final class SimulatorTests: XCTestCase {
    private var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
    }
    
    override func tearDown() {
        mockSession = nil
        super.tearDown()
    }
    
    func test_internalValue() {
        // Given
        let simulator = SimulatorType.internalSimulator
        
        // Then
        XCTAssertEqual(simulator.rawValue, "INTERNAL")
    }
    
    func test_externalValue() {
        // Given
        let simulator = SimulatorType.externalSimulator
        
        // Then
        XCTAssertEqual(simulator.rawValue, "EXTERNAL")
    }

    func test_urlSession_willPerformHTTPRedirection_withExpoAlternatePayments_shouldAllowRedirect() {
    // Given
    let sut = PSNetworkingService(
        session: mockSession,
        overrideSessionToBlockRedirects: true,
        authorizationKey: "testAuthKey",
        correlationId: "testCorrelationId",
        sdkVersion: "1.0.0"
    )
    
    let session = URLSession.shared
    // Create a mock task using URLSession.shared.dataTask to avoid deprecated initializer
    let task = URLSession.shared.dataTask(with: URL(string: "https://test.com")!)
    let response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 302, httpVersion: nil, headerFields: nil)!
    let request = URLRequest(url: URL(string: "https://expoalternatepayments.test.com")!)
    let expectation = self.expectation(description: "Completion handler called")
    
    var completionResult: URLRequest?
    
    // When
    sut.urlSession(
        session,
        task: task,
        willPerformHTTPRedirection: response,
        newRequest: request
    ) { urlRequest in
        completionResult = urlRequest
        expectation.fulfill()
    }
    
    // Then
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(completionResult)
    XCTAssertEqual(completionResult, request)
    }


    func test_urlSession_willPerformHTTPRedirection_withOtherURL_shouldBlockRedirect() {
        // Given
        let sut = PSNetworkingService(
            session: mockSession,
            overrideSessionToBlockRedirects: true,
            authorizationKey: "testAuthKey",
            correlationId: "testCorrelationId",
            sdkVersion: "1.0.0"
        )
        
        let session = URLSession.shared
        // Create a mock task using URLSession.shared.dataTask to avoid deprecated initializer
        let task = URLSession.shared.dataTask(with: URL(string: "https://test.com")!)
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 302, httpVersion: nil, headerFields: nil)!
        let request = URLRequest(url: URL(string: "https://other.test.com")!)
        let expectation = self.expectation(description: "Completion handler called")
        
        var completionResult: URLRequest?
        
        // When
        sut.urlSession(
            session,
            task: task,
            willPerformHTTPRedirection: response,
            newRequest: request
        ) { urlRequest in
            completionResult = urlRequest
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNil(completionResult)
    }


    func test_urlSession_willPerformHTTPRedirection_withExpoAlternatePaymentsInMixedCase_shouldAllowRedirect() {
        // Given
        let sut = PSNetworkingService(
            session: mockSession,
            overrideSessionToBlockRedirects: true,
            authorizationKey: "testAuthKey",
            correlationId: "testCorrelationId",
            sdkVersion: "1.0.0"
        )
        
        let session = URLSession.shared
        // Create a mock task using URLSession.shared.dataTask to avoid deprecated initializer
        let task = URLSession.shared.dataTask(with: URL(string: "https://test.com")!)
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 302, httpVersion: nil, headerFields: nil)!
        let request = URLRequest(url: URL(string: "https://ExPoAlTeRnAtEpAyMeNtS.test.com")!)
        let expectation = self.expectation(description: "Completion handler called")
        
        var completionResult: URLRequest?
        
        // When
        sut.urlSession(
            session,
            task: task,
            willPerformHTTPRedirection: response,
            newRequest: request
        ) { urlRequest in
            completionResult = urlRequest
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNil(completionResult, "Should not allow redirect for mixed case expoalternatepayments URL")
    }
}

// MARK: - Mock Classes

private class MockURLSession: URLSessionProtocol {
    var mockResponse: (Data, URLResponse)?
    var mockError: Error?
    var lastRequest: URLRequest?
    
    func psDataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        lastRequest = request
        
        if let error = mockError as? URLError {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let error = mockError {
            return Fail(error: URLError(.unknown, userInfo: [NSUnderlyingErrorKey: error])).eraseToAnyPublisher()
        }
        
        guard let (data, response) = mockResponse else {
            return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
        }
        
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}