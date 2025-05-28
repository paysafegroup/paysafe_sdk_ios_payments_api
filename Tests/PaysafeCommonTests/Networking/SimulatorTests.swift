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
        XCTAssertNotNil(completionResult, "Should allow redirect for mixed case expoalternatepayments URL with case-insensitive check")
        XCTAssertEqual(completionResult, request)
    }

    func test_urlSession_redirectionBlocked_whenShouldExpoAlternatePaymentsFalse() {
        // Given
        let expectation = expectation(description: "HTTP redirection is blocked")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        
        guard let url = URL(string: "https://www.example.com/regular-path") else {
            XCTFail("Failed to create URL")
            return
        }
        let request = URLRequest(url: url)
        
        // When
        service.urlSession(
            URLSession.shared,
            task: URLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(),
            newRequest: request
        ) { redirectRequest in
            // Then
            XCTAssertNil(redirectRequest, "Redirection request should be nil when shouldExpoAlternatePayments is false and URL doesn't contain 'expoalternatepayments'")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }

    func test_urlSession_handlesNilURLGracefully() {
        // Given
        let expectation = expectation(description: "Handle nil URL gracefully")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        
        // Create a request with nil URL
        _ = URLRequest(url: URL(string: "https://example.com")!)
        let requestWithNilURL = NSMutableURLRequest(url: URL(string: "https://example.com")!)
        requestWithNilURL.url = nil
        
        // When
        service.urlSession(
            URLSession.shared,
            task: URLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(),
            newRequest: requestWithNilURL as URLRequest
        ) { redirectRequest in
            // Then
            XCTAssertNil(redirectRequest, "Redirection request should be nil when request URL is nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }

    func test_urlSession_redirection_handlesCaseInsensitivity() {
        // Given
        let expectation = expectation(description: "HTTP redirection handles case sensitivity correctly")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        
        guard let url = URL(string: "https://www.example.com/ExPoAlTeRnAtEpAyMeNtS/callback") else {
            XCTFail("Failed to create URL")
            return
        }
        let request = URLRequest(url: url)
        
        // When
        service.urlSession(
            URLSession.shared,
            task: URLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(),
            newRequest: request
        ) { redirectRequest in
            // Then
            XCTAssertNotNil(redirectRequest, "Redirection request should be allowed when URL contains 'expoalternatepayments' in any case")
            XCTAssertEqual(redirectRequest, request, "Redirect request should match original request")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
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