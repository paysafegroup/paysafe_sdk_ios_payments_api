//
//  PSNetworkingServiceTests.swift
//
//
//  Copyright (c) 2025 Paysafe Group
//

import Combine
import Foundation
@testable import CommonMocks
@testable import PaysafeCommon
import XCTest

// Mock URLSessionTask for testing
private class MockURLSessionTask: URLSessionTask {
    override init() {
        super.init()
    }
}

final class PSNetworkingServiceTests: XCTestCase {
    var sut: PSNetworkingService!
    var mockSession: MockURLSession!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = PSNetworkingService(
            session: mockSession,
            authorizationKey: "authorizationKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        cancellables = []
    }

    override func tearDown() {
        mockSession = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    func test_request_information() {
        // Given
        let testUrl = "https://paysafe.com/api/data"
        let requestPayload = RequestMock(parameter: "Test")
        let httpMethod: HTTPMethod = .post

        // When
        sut.request(
            url: testUrl,
            httpMethod: httpMethod,
            payload: requestPayload
        )
        .sink { _ in } receiveValue: { (_: ResponseMock) in }
        .store(in: &cancellables)

        // Then
        XCTAssertEqual(mockSession.lastRequest?.url, URL(string: testUrl), "URL of the last request should match the expected URL")
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, httpMethod.rawValue, "HTTP method of the last request should be POST")
        XCTAssertEqual(mockSession.lastRequest?.timeoutInterval, 15, "Timeout interval of the last request should be 15 seconds.")
    }

    func test_request_success() throws {
        // Given
        let expectation = expectation(description: "Request succeeds")
        let testUrl = "https://paysafe.com"
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let mockResponse = ResponseMock(result: "Success")
        let mockResponseData = try XCTUnwrap(JSONEncoder().encode(mockResponse))
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil))
        let requestPayload = RequestMock(parameter: "Paysafe test")

        // Stub a successful response
        mockSession.stubSuccess(
            data: mockResponseData,
            response: mockURLResponse
        )

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: requestPayload
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { (response: ResponseMock) in
            // Then
            XCTAssertEqual(response.result, mockResponse.result)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_failure() {
        // Given
        let expectation = expectation(description: "Request fails")
        let expectedError = URLError(URLError.Code.badURL)

        let testUrl = "https://paysafe.com"
        let mockRequest = RequestMock(parameter: "Paysafe test")

        // Stub a failure response
        mockSession.stubFailure(error: expectedError)

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: mockRequest
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                // Then
                XCTAssertEqual(error.error.message, "Unhandled error occurred.")
                XCTAssertEqual(error.error.code, "9014")
                expectation.fulfill()
            case .finished:
                XCTFail("Request unexpectedly completed successfully.")
            }
        } receiveValue: { (_: ResponseMock) in
            XCTFail("Expected request to fail, received success.")
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_post_request_success() throws {
        // Given
        let expectation = expectation(description: "POST request succeeds")
        let testUrl = "https://paysafe.com/api/post"
        let requestPayload = RequestMock(parameter: "Test Payload")
        let mockResponse = ResponseMock(result: "Success")
        let mockResponseData = try XCTUnwrap(JSONEncoder().encode(mockResponse))
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil))

        // Stub a successful response
        mockSession.stubSuccess(
            data: mockResponseData,
            response: mockURLResponse
        )

        // When
        sut.request(
            url: testUrl,
            httpMethod: .post,
            payload: requestPayload
        )
        .sink { completion in
            if case .failure = completion {
                XCTFail("Expected success, received failure.")
            }
        } receiveValue: { (response: ResponseMock) in
            // Then
            XCTAssertEqual(response.result, mockResponse.result)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_encodingFailure() {
        // Given
        let expectation = expectation(description: "Request fails due to encoding error")
        let testUrl = "https://paysafe.com/api/post"
        let requestPayload = UnencodableMockRequest()

        // When
        sut.request(
            url: testUrl,
            httpMethod: .post,
            payload: requestPayload
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                // Then
                XCTAssertEqual(error.error.message, "Encoding error.")
                XCTAssertEqual(error.error.code, "9205")
                expectation.fulfill()
            case .finished:
                XCTFail("Expected request to fail, but it succeeded.")
            }
        } receiveValue: { (_: ResponseMock) in
            XCTFail("Expected request to fail, but it succeeded.")
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_with404Response() throws {
        // Given
        let expectation = expectation(description: "Handles 404 response correctly")
        let testUrl = "https://paysafe.com/nonexistent"
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 404, httpVersion: nil, headerFields: nil))
        let requestPayload = RequestMock(parameter: "Test")

        // Stub a 404 response
        mockSession.stubResponse(response: mockURLResponse)

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: requestPayload
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                // Then
                XCTAssertEqual(error.error.message, "Unhandled error occurred.")
                XCTAssertEqual(error.error.code, "9014")
                expectation.fulfill()
            case .finished:
                XCTFail("Expected request to fail due to 404 error, but it succeeded.")
            }
        } receiveValue: { (_: ResponseMock) in
            XCTFail("Expected request to fail due to 404 error, received success.")
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_success_withNonEmptyBody() throws {
        // Given
        let expectation = expectation(description: "Successful response with non-empty body")
        let testUrl = "https://paysafe.com/data"
        let requestPayload = RequestMock(parameter: "Test")
        let mockResponseData = try XCTUnwrap(JSONEncoder().encode(ResponseMock(result: "Success")))
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil))

        // Stub a 200 response
        mockSession.stubResponse(
            response: mockURLResponse,
            data: mockResponseData,
            error: nil
        )

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: requestPayload
        )
        .sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Request failed with error: \(error)")
            }
        } receiveValue: { (response: ResponseMock) in
            // Then
            XCTAssertEqual(response.result, "Success")
            expectation.fulfill()
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_success_withEmptyBody() throws {
        // Given
        let expectation = expectation(description: "Successful response with empty body")
        let testUrl = "https://paysafe.com/data"
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let requestPayload = RequestMock(parameter: "Test")
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 204, httpVersion: nil, headerFields: nil))

        // Stub a 204 response
        mockSession.stubResponse(
            response: mockURLResponse,
            data: Data(),
            error: nil
        )

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: requestPayload
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                XCTFail("Request failed with error: \(error)")
            case .finished:
                // Then
                expectation.fulfill()
            }
        } receiveValue: { (_: EmptyResponse) in }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_failure_withNonSuccessStatusCode() throws {
        // Given
        let expectation = expectation(description: "Non-success HTTP status code")
        let testUrl = "https://paysafe.com/data"
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let requestPayload = RequestMock(parameter: "Test")
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 404, httpVersion: nil, headerFields: nil))

        // Stub a 404 response
        mockSession.stubResponse(
            response: mockURLResponse,
            data: nil,
            error: nil
        )

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: requestPayload
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                // Then
                XCTAssertEqual(error.error.message, "Unhandled error occurred.")
                XCTAssertEqual(error.error.code, "9014")
                expectation.fulfill()
            case .finished:
                XCTFail("Expected request to fail due to 404 error, but it succeeded.")
            }
        } receiveValue: { (_: ResponseMock) in
            XCTFail("Expected request to fail due to 404 error, received success.")
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_emptyResponseParsingError() throws {
        // Given
        let expectation = expectation(description: "Handle empty response with parsing error")
        let testUrl = "https://paysafe.com"
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil))

        // Stub a 200 response
        mockSession.stubResponse(
            response: mockURLResponse,
            data: Data(),
            error: nil
        )

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: RequestMock(parameter: "Test")
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                // Then
                XCTAssertEqual(error.error.message, "Error communicating with server.")
                XCTAssertEqual(error.error.code, "9002")
                expectation.fulfill()
            case .finished:
                XCTFail("Expected request to fail due to parsing error, but it succeeded.")
            }
        } receiveValue: { (_: ResponseMock) in
            XCTFail("Expected failure, received success.")
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_request_jsonDecodingFailure() throws {
        // Given
        let expectation = expectation(description: "Handle JSON decoding failure")
        let testUrl = "https://paysafe.com"
        let mockUrl = try XCTUnwrap(URL(string: testUrl))
        let invalidJsonData = try XCTUnwrap("invalid json".data(using: .utf8))
        let mockURLResponse = try XCTUnwrap(HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil))

        // Stub a 200 response
        mockSession.stubResponse(
            response: mockURLResponse,
            data: invalidJsonData,
            error: nil
        )

        // When
        sut.request(
            url: testUrl,
            httpMethod: .get,
            payload: RequestMock(parameter: "Test")
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                // Then
                XCTAssertEqual(error.error.message, "Error communicating with server.")
                XCTAssertEqual(error.error.code, "9002")
                expectation.fulfill()
            case .finished:
                XCTFail("Expected request to fail due to parsing error, but it succeeded.")
            }
        } receiveValue: { (_: ResponseMock) in
            XCTFail("Expected failure, received success.")
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }
    
    // MARK: - URLSessionTaskDelegate Tests

    func test_urlSession_willPerformHTTPRedirection_noExpoUrl_shouldExpoAlternatePaymentsFalse_blocksRedirect() {
        // Given
        let expectation = expectation(description: "HTTP redirection is blocked for non-expo URL when shouldExpoAlternatePayments is false")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        // shouldExpoAlternatePayments is false by default after init
        
        guard let url = URL(string: "https://www.example.com/some/path") else {
            XCTFail("Failed to create URL for newRequest")
            return
        }
        let newRequest = URLRequest(url: url)
        
        // When
        service.urlSession(
            URLSession.shared, // Mocked session, not directly used by delegate logic
            task: MockURLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(), // Mocked response, not directly used
            newRequest: newRequest
        ) { redirectedRequest in
            // Then
            expectation.fulfill()
            XCTAssertNil(redirectedRequest, "Redirection request should be nil for non-expo URL when shouldExpoAlternatePayments is false.")
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_urlSession_willPerformHTTPRedirection_expoUrl_shouldExpoAlternatePaymentsFalse_allowsRedirect() {
        // Given
        let expectation = expectation(description: "HTTP redirection is allowed for expo URL even if shouldExpoAlternatePayments is false")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        // shouldExpoAlternatePayments is false by default after init
        
        guard let url = URL(string: "https://www.example.com/expoalternatepayments/callback") else {
            XCTFail("Failed to create URL for newRequest")
            return
        }
        let newRequest = URLRequest(url: url)
        
        // When
        service.urlSession(
            URLSession.shared,
            task: MockURLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(),
            newRequest: newRequest
        ) { redirectedRequest in
            // Then
            expectation.fulfill()
            XCTAssertEqual(redirectedRequest, newRequest, "Redirection should be allowed for URLs containing 'expoalternatepayments'.")
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_urlSession_willPerformHTTPRedirection_expoUrlMixedCase_shouldExpoAlternatePaymentsFalse_allowsRedirect() {
        // Given
        let expectation = expectation(description: "HTTP redirection is allowed for mixed-case expo URL when shouldExpoAlternatePayments is false with case-insensitive check")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        // shouldExpoAlternatePayments is false by default after init
        
        guard let url = URL(string: "https://www.example.com/ExPoAlTeRnAtEpAyMeNtS/callback") else {
            XCTFail("Failed to create URL for newRequest")
            return
        }
        let newRequest = URLRequest(url: url)
        
        // When
        service.urlSession(
            URLSession.shared,
            task: MockURLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(),
            newRequest: newRequest
        ) { redirectedRequest in
            // Then
            expectation.fulfill()
            XCTAssertEqual(redirectedRequest, newRequest, "Redirection request should be allowed for mixed-case 'expoalternatepayments' URL with case-insensitive check.")
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_urlSession_willPerformHTTPRedirection_nilNewUrl_shouldExpoAlternatePaymentsFalse_blocksRedirect() {
        // This test is similar to test_urlSession_handlesNilURLGracefully from SimulatorTests
        // Given
        let expectation = expectation(description: "HTTP redirection is blocked when newRequest URL is nil")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        // shouldExpoAlternatePayments is false by default after init

        // Create a request with a valid URL first, then set its URL to nil
        guard let validURL = URL(string: "https://example.com") else {
            XCTFail("Failed to create valid URL.")
            return
        }
        var newRequestWithNilURL = URLRequest(url: validURL)
        newRequestWithNilURL.url = nil
        
        // When
        service.urlSession(
            URLSession.shared,
            task: MockURLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(),
            newRequest: newRequestWithNilURL
        ) { redirectedRequest in
            // Then
            expectation.fulfill()
            XCTAssertNil(redirectedRequest, "Redirection request should be nil when the new request's URL is nil.")
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_urlSession_willPerformHTTPRedirection_whenShouldExpoAlternatePaymentsIsTrue_allowsRedirect() {
        // Given
        let expectation = expectation(description: "HTTP redirection is allowed when shouldExpoAlternatePayments is true")
        let service = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: "authKey",
            correlationId: "correlationId",
            sdkVersion: "sdkVersion"
        )
        
        // Set shouldExpoAlternatePayments to true via the request method
        let _: AnyPublisher<EmptyResponse, APIError> = service.request(
            url: "https://example.com",
            httpMethod: .get,
            payload: EmptyRequest(),
            expoAlternatePayments: true
        )
        
        // Create a regular URL that doesn't contain "expoalternatepayments"
        guard let url = URL(string: "https://www.example.com/regular/path") else {
            XCTFail("Failed to create URL for newRequest")
            return
        }
        let newRequest = URLRequest(url: url)
        
        // When
        service.urlSession(
            URLSession.shared,
            task: MockURLSessionTask(),
            willPerformHTTPRedirection: HTTPURLResponse(),
            newRequest: newRequest
        ) { redirectedRequest in
            // Then
            expectation.fulfill()
            XCTAssertEqual(redirectedRequest, newRequest, "Redirection request should be allowed when shouldExpoAlternatePayments is true")
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}