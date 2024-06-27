//
//  MockURLSession.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation
import PaysafeCommon
@testable import PaysafeNetworking

public final class MockURLSession: URLSessionProtocol {
    var lastRequest: URLRequest?
    var stubbedData: Data?
    var stubbedResponse: URLResponse?
    var stubbedError: URLError?
    
    public init() { }

    public func psDataTaskPublisher(
        for request: URLRequest
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        lastRequest = request
        return Future { [weak self] promise in
            guard let self else { return }
            if let stubbedError {
                promise(.failure(stubbedError))
            } else if let stubbedResponse {
                let data = stubbedData ?? Data()
                promise(.success((data, stubbedResponse)))
            } else {
                promise(.failure(URLError(URLError.Code.badServerResponse)))
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - Convenience methods for setting stubs
public extension MockURLSession {
    func stubSuccess(data: Data, response: URLResponse = HTTPURLResponse()) {
        stubbedData = data
        stubbedResponse = response
        stubbedError = nil
    }

    func stubFailure(error: URLError) {
        stubbedData = nil
        stubbedResponse = nil
        stubbedError = error
    }

    func stubResponse(response: URLResponse? = nil, data: Data? = nil, error: URLError? = nil) {
        stubbedData = data
        stubbedResponse = response
        stubbedError = error
    }
}
