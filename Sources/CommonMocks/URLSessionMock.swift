//
//  URLSessionMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation
@testable import PaysafeCommon

public final class URLSessionMock: URLSessionProtocol {
    var lastRequest: URLRequest?

    private var stubs = [URL: (Data?, URLResponse?, URLError?)]()

    public init(lastRequest: URLRequest? = nil, stubs: [URL : (Data?, URLResponse?, URLError?)] = [URL: (Data?, URLResponse?, URLError?)]()) {
        self.lastRequest = lastRequest
        self.stubs = stubs
    }
    
    public func psDataTaskPublisher(
        for request: URLRequest
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        lastRequest = request
        return Future { [weak self] promise in
            guard let self else {
                return
            }
            if let url = request.url,
               let (data, response, error) = self.stubs[url] {
                if let error {
                    promise(.failure(error))
                } else if let response {
                    let data = data ?? Data()
                    promise(.success((data, response)))
                } else {
                    promise(.failure(URLError(URLError.Code.badServerResponse)))
                }
            } else {
                promise(.failure(URLError(URLError.Code.badURL)))
            }
        }.eraseToAnyPublisher()
    }
    
    public func stubRequest(url: URL, data: Data?, response: URLResponse?, error: URLError?) {
        stubs[url] = (data, response, error)
    }
}
