//
//  PSLogger.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
#if canImport(PaysafeCommon)
@_spi(PS) import PaysafeCommon
import PaysafeNetworking
#endif

/// PSLogger
final class PSLogger {
    /// Paysafe API key
    private let apiKey: String
    /// Correlation id
    private let correlationId: String
    /// Base URL
    private let baseURL: String
    /// IntegrationType
    private let integrationType: IntegrationType
    /// PSNetworkingService
    var networkingService: PSNetworkingService
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()

    /// - Parameters:
    ///   - apiKey: Merchants API key
    ///   - correlationId: Correlation id
    ///   - baseURL: Base url
    ///   - integrationType: Integration type
    init(
        apiKey: String,
        correlationId: String,
        baseURL: String,
        integrationType: IntegrationType
    ) {
        self.apiKey = apiKey
        self.correlationId = correlationId
        self.baseURL = baseURL
        self.integrationType = integrationType
        networkingService = PSNetworkingService(
            authorizationKey: apiKey,
            correlationId: correlationId,
            sdkVersion: SDKConfiguration.sdkVersion
        )
    }
}

// MARK: - Default logs
extension PSLogger {
    /// Log events.
    ///
    /// - CONVERSION is used to log all major events resulting in state change of the SDK including successful invocation of API like: SDK is initialized,
    ///     tokenization is invoked, paymentMethods API call is successful, Cardinal commerce devicefingerprinting is completed.
    /// - WARN is currently being used to log Apple Pay related errors like merchant domain is not validated with Apple or device doesn't support Apple Pay.
    /// - ERROR is used to log error events occurring in SDK and the error codes returned to Merchants by Mobile SDKs.
    ///
    /// - Parameters:
    ///   - eventType: EventType
    ///   - message: Message to be added to the log request
    func log(eventType: EventType, message: String) {
        log(PSEvent(type: eventType, message: message))
    }

    /// Method that logs an event.
    ///
    /// - Parameters:
    ///   - event: PSEvent
    private func log(_ event: PSEvent) {
        let request = LogRequest(
            type: event.type,
            clientInfo: ClientInfo(
                version: SDKConfiguration.sdkVersion,
                correlationId: correlationId,
                apiKey: apiKey,
                integrationType: integrationType
            ),
            payload: LogPayload(message: event.message)
        )
        send(request)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("[PSLogger] Log failed for payload: \(request) with error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Do nothing with the received value
            }
            .store(in: &cancellables)
    }

    /// Method that sends the log request.
    ///
    /// - Parameters:
    ///   - request: Log request
    private func send(_ request: LogRequest) -> AnyPublisher<EmptyResponse, APIError> {
        let loggerURL = baseURL + "/mobile/api/v1/log"
        return networkingService.request(
            url: loggerURL,
            httpMethod: .post,
            payload: [request]
        )
    }
}

// MARK: - 3DS logs
extension PSLogger {
    /// Log 3DS events.
    ///
    /// - INTERNAL_SDK_ERROR is used to log all internal 3DS sdk errors.
    /// - VALIDATION_ERROR is used to log 3DS sdk validation errors.
    /// - SUCCESS is used to log success 3DS sdk events
    /// - NETWORK_ERROR is used to log 3DS sdk network errors.
    ///
    /// - Parameters:
    ///   - eventType: ThreeDSEventType
    ///   - message: Message to be added to the log request
    func log3DS(eventType: ThreeDSEventType, message: String) {
        log(PSThreeDSEvent(type: eventType, message: message))
    }

    /// Method that logs a 3DS event.
    ///
    /// - Parameters:
    ///   - event: PSThreeDSEvent
    private func log(_ event: PSThreeDSEvent) {
        let request = ThreeDSLogRequest(
            eventType: event.type,
            eventMessage: event.message,
            sdk: ThreeDSClientInfo(version: SDKConfiguration.sdkVersion)
        )
        send(request)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("[PSLogger] Log failed for payload: \(request) with error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Do nothing with the received value
            }
            .store(in: &cancellables)
    }

    /// Method that sends the 3DS log request.
    ///
    /// - Parameters:
    ///   - request: Log request
    private func send(_ request: ThreeDSLogRequest) -> AnyPublisher<EmptyResponse, APIError> {
        let loggerURL = baseURL + "/threedsecure/v2/log"
        return networkingService.request(
            url: loggerURL,
            httpMethod: .post,
            payload: request
        )
    }
}
