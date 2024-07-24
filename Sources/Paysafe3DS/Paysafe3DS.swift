//
//  Paysafe3DS.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import CardinalMobile
import Combine
#if canImport(PaysafeCommon)
@_spi(PS) import PaysafeCommon
#endif

/// Completion typealias used in the `initiate3DSFlow` method that contains a result of deviceFingerprintingId or a PSError.
public typealias PaysafeInitiate3DSFlowCompletion = (Result<String, PSError>) -> Void
/// Completion typealias used in the `startChallenge` method that contains a result of authenticationId or a PSError.
public typealias PaysafeStart3DSChallengeCompletion = (Result<String, PSError>) -> Void

/// Paysafe3DS module. The Paysafe3DS module is responsable for handling the 3D Secure authentication in a seamless way.
/// Paysafe3DS can be used as a standolone module by the merchants.
///
/// - Note: The apiKey is provided by the Paysafe Team representing a base64 encoded string. The Configuration object has the following parameters:
/// * environment:  Environment used: staging or production
/// * requestTimeout: Sets the maximum amount of time (in milliseconds) for all exchanges
/// * challengeTimeout: Challenge timeout in minutes
/// * supportedUI:  Interface types that the device supports for displaying specific challenge user interfaces within the SDK.
/// * renderType:  List of all the RenderTypes that the device supports for displaying specific challenge user interfaces within the SDK
/// - Parameters:
///   - apiKey: Paysafe API key
///   - environment: API Environment
public class Paysafe3DS {
    /// PSNetworkingService
    var networkingService: PSNetworkingService
    /// CardinalSession
    var session: CardinalSession
    /// Paysafe3DS configuration
    public var configuration: Configuration
    /// Start challenge subject
    private let startChallengeSubject = PassthroughSubject<Result<String, PSError>, Never>()
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()
    /// Correlation id used for tracking purposes
    private let correlationId = UUID().uuidString.lowercased()

    /// Initialiser for the Paysafe3DS. Use this method to initialise a new instance of the Paysafe3DS class.
    /// The required parameters are: apiKey & environment. Paysafe3DS can be used as an independent module.
    ///
    /// - Note: The apiKey is provided by the Paysafe Team representing a base64 encoded string
    /// - Parameters:
    ///   - apiKey: Paysafe API key
    ///   - environment: API Environment
    public init(
        apiKey: String,
        environment: APIEnvironment
    ) {
        networkingService = PSNetworkingService(
            authorizationKey: apiKey,
            correlationId: correlationId,
            sdkVersion: SDKConfiguration.sdkVersion
        )
        session = CardinalSession()
        configuration = Configuration(environment: environment)
    }

    /// Paysafe3DS method used to initiate the 3D Secure flow.
    ///
    /// - Note: Paysafe3DSOptions
    /// * accountId: Merchants account id
    /// * bin: Card bin
    /// - Parameters:
    ///   - options: Paysafe3DSOptions
    /// - Returns:Publisher that publishes a String representing the deviceFingerprintingId or a PSError.
    /// - Note: PSError
    /// * badRequest
    /// * notFound
    /// * serverError
    /// * parsingError
    /// * unknown
    /// * threeDSServiceError
    /// * threeDSUserCancelled
    /// * threeDSTimeout
    /// * threeDSFailedValidation
    /// * threeDSUnknown
    public func initiate3DSFlow(
        using options: Paysafe3DSOptions,
        and supportedUI: SupportedUI? = nil
    ) -> AnyPublisher<String, PSError> {
        if let supportedUI {
            configuration.supportedUI = supportedUI
        }
        session.configure(configuration.cardinalSessionConfiguration)
        return getJWT(
            using: options.accountId,
            and: options.bin
        )
        .flatMap { [weak self] jwtResponse -> AnyPublisher<String, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError()).eraseToAnyPublisher()
            }
            return setup3DSSession(
                using: jwtResponse
            )
        }
        .eraseToAnyPublisher()
    }

    /// Paysafe3DS method used to initiate the 3D Secure flow.
    ///
    /// - Note: Paysafe3DSOptions
    /// * accountId: Merchants account id
    /// * bin: Card bin
    /// - Parameters:
    ///   - options: Paysafe3DSOptions
    ///   - completion : PaysafeInitiate3DSFlowCompletion
    /// - Returns: Callback with a result of a string representing the deviceFingerprintingId or a PSError.
    /// - Note: PSError
    /// * badRequest
    /// * notFound
    /// * serverError
    /// * parsingError
    /// * unknown
    /// * threeDSServiceError
    /// * threeDSUserCancelled
    /// * threeDSTimeout
    /// * threeDSFailedValidation
    /// * threeDSUnknown
    public func initiate3DSFlow(
        using options: Paysafe3DSOptions,
        and supportedUI: SupportedUI? = nil,
        completion: @escaping PaysafeInitiate3DSFlowCompletion
    ) {
        initiate3DSFlow(using: options,
                        and: supportedUI)
            .sink { publisherCompletion in
                switch publisherCompletion {
                case .finished:
                    break
                case let .failure(error):
                    completion(.failure(error))
                }
            } receiveValue: { token in
                completion(.success(token))
            }
            .store(in: &cancellables)
    }

    /// Start challenge for `pending` authentication status then finalize the authentication.
    ///
    /// - Parameters:
    ///   - payload: SDK challenge payload provided by the /authentications endpoint, a base64 encoded string
    public func startChallenge(
        using payload: String?
    ) -> AnyPublisher<String, PSError> {
        startChallenge(
            using: payload
        )
        .flatMap { [weak self] finalizeOptions -> AnyPublisher<String, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError()).eraseToAnyPublisher()
            }
            return finalizeAuthentication(
                using: finalizeOptions
            )
            .map { _ in finalizeOptions.authenticationId }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    /// Start challenge for `pending` authentication status then finalize the authentication.
    ///
    /// - Parameters:
    ///   - payload: SDK challenge payload provided by the /authentications endpoint, a base64 encoded string
    ///   - completion: PaysafeStart3DSChallengeCompletion
    public func startChallenge(
        using payload: String?,
        completion: @escaping PaysafeStart3DSChallengeCompletion
    ) {
        startChallenge(using: payload)
            .sink { publisherCompletion in
                switch publisherCompletion {
                case .finished:
                    break
                case let .failure(error):
                    completion(.failure(error))
                }
            } receiveValue: { token in
                completion(.success(token))
            }
            .store(in: &cancellables)
    }

    /// Update render type based on merchant input.
    ///
    /// - Parameters:
    ///   - merchantRenderType: The render type, identified as SupportedUI in Cardinal, the merchant wants to support.
    public func updateRenderType(
        using merchantRenderType: SupportedUI
    ) {
        configuration.supportedUI = merchantRenderType
    }
}

// MARK: - Private
private extension Paysafe3DS {
    /// Get jwt token method
    ///
    /// - Parameters:
    ///   - accountId: Account id
    ///   - cardBin: Card bin
    func getJWT(
        using accountId: String,
        and cardBin: String
    ) -> AnyPublisher<JWTResponse, PSError> {
        let jwtRequest = JWTRequest(
            card: ThreeDSCardDetailsRequest(cardBin: cardBin),
            accountId: accountId
        )
        let getJWTUrl = configuration.environment.baseURL + "/threedsecure/v2/jwt"
        return networkingService.request(
            url: getJWTUrl,
            httpMethod: .post,
            payload: jwtRequest
        )
        .mapError { [weak self] error in
            guard let self else {
                return PSError.genericAPIError()
            }
            return error.from3DStoPSError(correlationId)
        }
        .eraseToAnyPublisher()
    }

    /// Paysafe3DS method used to setup the 3D Secure session. Expected return `deviceFingerprintingId`.
    ///
    /// - Parameters:
    ///   - response: JWTResponse
    /// - Note: PSError
    /// * badRequest
    /// * notFound
    /// * serverError
    /// * parsingError
    /// * unknown
    /// * threeDSServiceError
    /// * threeDSUserCancelled
    /// * threeDSTimeout
    /// * threeDSFailedValidation
    /// * threeDSUnknown
    func setup3DSSession(
        using response: JWTResponse
    ) -> AnyPublisher<String, PSError> {
        Future { [weak self] promise in
            guard let self else { return }
            session.setup(jwtString: response.jwt) { _ in
                promise(.success(response.deviceFingerprintingId))
            } validated: { [weak self] response in
                guard let self, !response.isValidated else { return }
                promise(.failure(.threeDSFailedValidation(correlationId)))
            }
        }.eraseToAnyPublisher()
    }

    /// Start challenge for `pending` authentication status
    ///
    /// - Parameters:
    ///   - payload: SDK challenge payload provided by the /authentications endpoint, a base64 encoded string
    func startChallenge(
        using payload: String?
    ) -> AnyPublisher<FinalizeAuthenticationOptions, PSError> {
        guard let challengePayload = SDKChallengePayload.challenge(from: payload) else {
            return Fail(error: .threeDSChallengePayloadError(correlationId)).eraseToAnyPublisher()
        }
        session.continueWith(
            transactionId: challengePayload.transactionId,
            payload: challengePayload.payload,
            validationDelegate: self
        )
        return startChallengeSubject
            .setFailureType(to: PSError.self)
            .flatMap { result -> AnyPublisher<FinalizeAuthenticationOptions, PSError> in
                switch result {
                case let .success(serverJWT):
                    let options = FinalizeAuthenticationOptions(
                        accountId: challengePayload.accountId,
                        authenticationId: challengePayload.id,
                        serverJWT: serverJWT
                    )
                    return Just(options).setFailureType(to: PSError.self).eraseToAnyPublisher()
                case let .failure(error):
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    /// Finalize 3DS authentication
    ///
    /// - Parameters:
    ///   - options: Finalize authentication options
    func finalizeAuthentication(
        using options: FinalizeAuthenticationOptions
    ) -> AnyPublisher<EmptyResponse, PSError> {
        let finalizeRequest = FinalizeAuthenticationRequest(payload: options.serverJWT)
        let url = configuration.environment.baseURL + "/threedsecure/v2/accounts/\(options.accountId)/authentications/\(options.authenticationId)/finalize"
        return networkingService.request(
            url: url,
            httpMethod: .post,
            payload: finalizeRequest
        )
        .mapError { [weak self] apiError in
            guard let self else {
                return PSError.genericAPIError()
            }
            return apiError.from3DStoPSError(correlationId)
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - CardinalValidationDelegate
extension Paysafe3DS: CardinalValidationDelegate {
    /// https://cardinaldocs.atlassian.net/wiki/spaces/CMSDK/pages/2005696790/Handle+the+Centinel+Lookup+Response+and+SDK+handle+the+Challenge+UI+-+iOS
    public func cardinalSession(cardinalSession session: CardinalSession?, stepUpValidated validateResponse: CardinalResponse?, serverJWT: String?) {
        // Skip validateResponse check in unit tests
        guard NSClassFromString("XCTest") == nil else {
            if let serverJWT {
                return startChallengeSubject.send(.success(serverJWT))
            } else {
                return startChallengeSubject.send(.failure(.genericAPIError(correlationId)))
            }
        }
        guard let validateResponse else {
            return startChallengeSubject.send(.failure(.genericAPIError(correlationId)))
        }
        switch validateResponse.actionCode {
        case .success, .noAction:
            guard validateResponse.isValidated, let serverJWT else { return startChallengeSubject.send(.failure(.threeDSFailedValidation(correlationId))) }
            startChallengeSubject.send(.success(serverJWT))
        case .failure, .error:
            let error = PSError.threeDSSessionFailure(
                correlationId,
                message: "Error code: \(validateResponse.errorNumber)"
            )
            startChallengeSubject.send(.failure(error))
        case .cancel:
            startChallengeSubject.send(.failure(.threeDSUserCancelled(correlationId)))
        case .timeout:
            startChallengeSubject.send(.failure(.threeDSTimeout(correlationId)))
        @unknown default:
            startChallengeSubject.send(.failure(.genericAPIError(correlationId)))
        }
    }
}
