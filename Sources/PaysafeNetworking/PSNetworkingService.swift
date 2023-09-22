//
//  PSNetworkingService.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

public protocol RequestPerforming {
    func request<RequestType: Encodable, ResponseType: Decodable>(
        url: String,
        httpMethod: HTTPMethod,
        payload: RequestType,
        invocationId: String?,
        transactionSource: String
    ) -> AnyPublisher<ResponseType, APIError>
}

public protocol URLSessionProtocol {
    func psDataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionProtocol {
    public func psDataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        dataTaskPublisher(for: request)
            .map { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }
}

public class PSNetworkingService: RequestPerforming {
    /// URLSessionProtocol
    private let session: URLSessionProtocol
    /// Authorization key
    private let authorizationKey: String
    /// Correlation id
    private let correlationId: String
    /// SDK version
    private let sdkVersion: String
    /// Timeout interval, configured at 15 seconds.
    private let timeoutInterval: TimeInterval = 15

    /// - Parameters:
    ///   - session: URLSessionProtocol
    ///   - authorizationKey: Authorization key
    ///   - correlationId: Correlation id
    ///   - sdkVersion: SDK version
    public init(
        session: URLSessionProtocol = URLSession.shared,
        authorizationKey: String,
        correlationId: String,
        sdkVersion: String
    ) {
        self.session = session
        self.authorizationKey = authorizationKey
        self.correlationId = correlationId
        self.sdkVersion = sdkVersion
    }

    /// Request method
    ///
    /// - Parameters:
    ///   - url: Request URL
    ///   - httpMethod: Request HTTP method
    ///   - payload: Request payload
    public func request<RequestType: Encodable, ResponseType: Decodable>(
        url: String,
        httpMethod: HTTPMethod,
        payload: RequestType,
        invocationId: String? = nil,
        transactionSource: String = "IosSDKV2"
    ) -> AnyPublisher<ResponseType, APIError> {
        guard let requestURL = URL(string: url) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: requestURL, timeoutInterval: timeoutInterval)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Basic \(authorizationKey)",
            "X-INTERNAL-CORRELATION-ID": correlationId,
            "X-App-Version": sdkVersion,
            "X-TransactionSource": transactionSource
        ]
        if let invocationId {
            request.addValue(invocationId, forHTTPHeaderField: "Invocationid")
            request.addValue("EXTERNAL", forHTTPHeaderField: "Simulator")
        }

        if case .post = httpMethod {
            do {
                let data = try JSONEncoder().encode(payload)
                logData(title: "REQUEST", data: data)
                request.httpBody = data
            } catch {
                return Fail(error: .encodingError).eraseToAnyPublisher()
            }
        }

        return session.psDataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                self?.logData(title: "RESPONSE", data: data)
                return (data, httpResponse)
            }
            .tryMap { data, httpResponse in
                switch httpResponse.statusCode {
                case 200...299:
                    guard !data.isEmpty else {
                        guard let emptyObject = EmptyResponse() as? ResponseType else {
                            throw APIError.invalidResponse
                        }
                        return emptyObject
                    }
                    do {
                        return try JSONDecoder().decode(ResponseType.self, from: data)
                    } catch {
                        throw APIError.invalidResponse
                    }
                default:
                    throw (try? JSONDecoder().decode(APIError.self, from: data)) ?? APIError.genericAPIError
                }
            }
            .mapError { error in
                switch error {
                case let apiError as APIError:
                    return apiError
                case let urlError as NSError where urlError.code == NSURLErrorTimedOut:
                    return .timeoutError
                case let urlError as NSError where urlError.code == NSURLErrorNotConnectedToInternet:
                    return .noConnectionToServer
                default:
                    return .genericAPIError
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private
private extension PSNetworkingService {
    /// Log console data on debug builds.
    ///
    /// - Parameters:
    ///   - title: Log title
    ///   - data: Request HTTP method
    func logData(title: String, data: Data) {
#if DEBUG
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue),
              jsonString != "{\n\n}" else { return }
        print("\n======================== \(title) ========================\n")
        print(jsonString)
        print("\n====================== END \(title) ======================\n")
#endif
    }
}
