//
//  PSAPIClient.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation
#if canImport(PaysafeCommon)
import Paysafe3DS
@_spi(PS) import PaysafeCommon
import PaysafeNetworking
#endif

// swiftlint:disable file_length
/// PaysafeCore module. The PaysafeCore module is responsable for initialising the PSAPIClient class and handle payment flows.
///
/// - Note: The apiKey is provided by the Paysafe Team representing a base64 encoded string.
/// - Parameters:
///   - apiKey: Paysafe API key
///   - environment: API Environment
public class PSAPIClient {
    /// PSNetworkingService
    var networkingService: PSNetworkingService
    /// Paysafe3DS
    var paysafe3DS: Paysafe3DS
    /// Paysafe environment
    let environment: PaysafeEnvironment
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()
    /// PSLogger
    private let logger: PSLogger
    /// Tokenize in progress flag
    private var tokenizeInProgress = false
    /// Render type used for 3ds if merchant sets a value
    private var renderType: RenderType?
    /// Account id used for current tokenize flow
    private var accountId: String?
    /// Base url for return links
    private let baseHref = "https://usgaminggamblig.com/payment/return/"

    /// - Parameters:
    ///   - apiKey: Paysafe API key
    ///   - environment: Paysafe environment
    init(
        apiKey: String,
        environment: PaysafeEnvironment
    ) {
        self.environment = environment
        networkingService = PSNetworkingService(
            authorizationKey: apiKey,
            correlationId: PaysafeSDK.shared.correlationId,
            sdkVersion: SDKConfiguration.sdkVersion
        )
        paysafe3DS = Paysafe3DS(
            apiKey: apiKey,
            environment: environment.to3DSEnvironment()
        )
        logger = PSLogger(
            apiKey: apiKey,
            correlationId: PaysafeSDK.shared.correlationId,
            baseURL: environment.baseURL,
            integrationType: .paymentsApi
        )
        logEvent("Object passed on PSAPIClient init: environment: \(environment)")
    }

    /// Get the payment method associated with `currencyCode` and `accountId`.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - completion: PSPaymentMethodBlock
    func getPaymentMethod(
        currencyCode: String,
        accountId: String,
        completion: @escaping PSPaymentMethodBlock
    ) {
        let startRequestTime = Date()
        getAvailablePaymentMethods(
            for: currencyCode
        )
        .sink { [weak self] publisherCompletion in
            switch publisherCompletion {
            case .finished:
                break
            case let .failure(error):
                self?.logEvent(error)
                completion(.failure(error))
            }
        } receiveValue: { [weak self] paymentMethodsResponse in
            guard let self else { return }
            let durationInMilliseconds = Int(Date().timeIntervalSince(startRequestTime) * 1000)
            logEvent("Payment method configuration was successfully loaded in \(durationInMilliseconds) ms")
            let paymentMethod = paymentMethodsResponse.paymentMethods
                .compactMap { $0.toPaymentMethod() }
                .first { $0.accountId == accountId }
            if let paymentMethod {
                completion(.success(paymentMethod))
            } else {
                let error = PSError.coreInvalidAccountId(
                    PaysafeSDK.shared.correlationId,
                    message: "Invalid account id for \(paymentMethod?.paymentMethod ?? .unknown)."
                )
                logEvent(error)
                completion(.failure(error))
            }
        }
        .store(in: &cancellables)
    }

    /// PaysafeCore tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSTokenizeOptions
    ///   - card: CardRequest
    func tokenize(
        options: PSTokenizable,
        paymentType: PaymentType,
        card: CardRequest? = nil
    ) -> AnyPublisher<PaymentHandle, PSError> {
        guard !tokenizeInProgress else {
            let error = PSError.coreTokenizationAlreadyInProgress(PaysafeSDK.shared.correlationId)
            logEvent(error)
            return Fail(error: error).eraseToAnyPublisher()
        }
        accountId = options.accountId
        if let cardOptions = options as? PSCardTokenizeOptions {
            renderType = cardOptions.renderType
        }
        tokenizeInProgress = true
        return getSingleUsePaymentHandle(
            options: options,
            paymentType: paymentType,
            card: card
        )
        .flatMap { [weak self] paymentResponse -> AnyPublisher<PaymentHandle, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            let shouldProcessTransaction: Bool? = {
                switch options {
                case let cardOptions as PSCardTokenizeOptions:
                    return cardOptions.threeDS?.process
                default:
                    return nil
                }
            }()
            return handlePaymentResponse(
                using: paymentResponse,
                process: shouldProcessTransaction
            )
        }
        .handleEvents(
            receiveOutput: { [weak self] _ in
                self?.tokenizeInProgress = false
            },
            receiveCompletion: { [weak self] _ in
                self?.tokenizeInProgress = false
            }
        )
        .catch { [weak self] error -> AnyPublisher<PaymentHandle, PSError> in
            self?.logEvent(error)
            return Fail(error: error).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    /// Refresh payment token.
    ///
    /// - Parameters:
    ///   - paymentHandleToken: Payment handle token
    ///   - retryCount: Number of retry attempts, default as 3
    ///   - delayInSeconds: Delay between retries, default as 6 seconds
    func refreshPaymentToken(
        using paymentHandleToken: String,
        and retryCount: Int = 3,
        and delayInSeconds: TimeInterval = 6
    ) -> AnyPublisher<Void, PSError> {
        getPaymentHandleTokenStatus(
            using: paymentHandleToken
        )
        .flatMap { [weak self] refreshPaymentHandleTokenResponse -> AnyPublisher<Void, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return handleRefreshPaymentHandleTokenResponse(
                using: refreshPaymentHandleTokenResponse,
                and: retryCount,
                and: delayInSeconds
            )
        }
        .eraseToAnyPublisher()
    }

    /// Log event with message.
    ///
    /// - Parameters:
    ///   - message: Message to be added to the log request
    func logEvent(_ message: String) {
        guard !performsUnitTests() else { return }
        logger.log(eventType: .conversion, message: message)
    }

    /// Log event with PSError.
    ///
    /// - Parameters:
    ///   - error: Error object to be added to the log request
    func logEvent(_ error: PSError) {
        guard !performsUnitTests() else { return }
        switch error.errorCode.type {
        case .apiError, .coreError, .applePayError, .payPalError, .cardFormError:
            logger.log(eventType: .conversion, message: error.toLogError().jsonString())
        case .threeDSError:
            logger.log3DS(eventType: .internalSDKError, message: error.detailedMessage)
        }
    }
}

// MARK: - Private
private extension PSAPIClient {
    /// Get available payment methods.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    func getAvailablePaymentMethods(
        for currencyCode: String
    ) -> AnyPublisher<PaymentMethodsResponse, PSError> {
        let getAvailablePaymentMethodsUrl = environment.baseURL + "/paymenthub/v1/paymentmethods?currencyCode=\(currencyCode)"
        return networkingService.request(
            url: getAvailablePaymentMethodsUrl,
            httpMethod: .get,
            payload: EmptyRequest()
        )
        .mapError { _ in PSError.coreFailedToFetchAvailablePayments(PaysafeSDK.shared.correlationId) }
        .eraseToAnyPublisher()
    }

    /// Get single use payment handle method.
    ///
    /// - Parameters:
    ///   - options: PSTokenizeOptions
    ///   - card: CardRequest
    ///   - singleUseCustomerToken: String
    ///   - paymentTokenFrom: String
    func getSingleUsePaymentHandle(
        options: PSTokenizable,
        paymentType: PaymentType,
        card: CardRequest? = nil,
        singleUseCustomerToken: String? = nil,
        paymentTokenFrom: String? = nil
    ) -> AnyPublisher<PaymentResponse, PSError> {
        let paymentRequest = paymentRequest(
            options: options,
            paymentType: paymentType,
            card: card
        )
        let invocationId = UUID().uuidString.lowercased()
        logEvent("Options object passed on tokenize: \(options.jsonString()), invocationId: \(invocationId)")
        let tokenizeUrl = environment.baseURL + "/paymenthub/v1/singleusepaymenthandles"
        return networkingService.request(
            url: tokenizeUrl,
            httpMethod: .post,
            payload: paymentRequest,
            invocationId: invocationId,
            transactionSource: paymentType == .payPal ? "PaysafeJSV1" : "IosSDKV2"
        )
        .mapError { $0.toPSError(PaysafeSDK.shared.correlationId) }
        .eraseToAnyPublisher()
    }

    /// Create and prepare payment request for saved card payment or new card payment
    ///
    /// - Parameters:
    ///   - options: PSTokenizeOptions
    ///   - card: CardRequest
    func paymentRequest(
        options: PSTokenizable,
        paymentType: PaymentType,
        card: CardRequest?
    ) -> PaymentRequest? {
        switch options {
        case let options as PSCardTokenizeOptions:
            return cardPaymentRequest(
                from: options,
                card: card
            )
        case let options as PSApplePayTokenizeOptions:
            return applePaymentRequest(
                from: options
            )
        case let options as PSPayPalTokenizeOptions:
            return payPalPaymentRequest(from: options)
        default:
            return nil
        }
    }

    func cardPaymentRequest(
        from options: PSCardTokenizeOptions,
        card: CardRequest?
    ) -> PaymentRequest {
        let savedCardTokens = SavedCardTokens(
            singleUseCustomerToken: options.singleUseCustomerToken,
            paymentToken: options.paymentTokenFrom
        )

        return PaymentRequest(
            merchantRefNum: options.merchantRefNum,
            transactionType: options.transactionType.request,
            card: cardDetails(using: card, isNewCard: savedCardTokens == nil),
            accountId: options.accountId,
            paymentType: .card,
            amount: options.amount,
            currencyCode: options.currencyCode,
            returnLinks: [
                ReturnLink(
                    rel: .defaultAction,
                    href: baseHref,
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onCompleted,
                    href: "\(baseHref)success",
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onFailed,
                    href: "\(baseHref)failed",
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onCancelled,
                    href: "\(baseHref)cancelled",
                    method: "GET"
                )
            ],
            profile: options.profile?.request,
            threeDs: options.threeDS?.request(using: options.merchantRefNum),
            billingDetails: options.billingDetails?.request,
            merchantDescriptor: options.merchantDescriptor?.request,
            shippingDetails: options.shippingDetails?.request,
            singleUseCustomerToken: savedCardTokens?.singleUseCustomerToken,
            paymentHandleTokenFrom: savedCardTokens?.paymentToken,
            applePay: nil,
            paypal: nil
        )
    }

    func applePaymentRequest(from options: PSApplePayTokenizeOptions) -> PaymentRequest {
        PaymentRequest(
            merchantRefNum: options.merchantRefNum,
            transactionType: options.transactionType.request,
            card: nil,
            accountId: options.accountId,
            paymentType: .card,
            amount: options.amount,
            currencyCode: options.currencyCode,
            returnLinks: [
                ReturnLink(
                    rel: .defaultAction,
                    href: baseHref,
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onCompleted,
                    href: "\(baseHref)success",
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onFailed,
                    href: "\(baseHref)failed",
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onCancelled,
                    href: "\(baseHref)cancelled",
                    method: "GET"
                )
            ],
            profile: options.profile?.request,
            threeDs: nil,
            billingDetails: options.billingDetails?.request,
            merchantDescriptor: options.merchantDescriptor?.request,
            shippingDetails: options.shippingDetails?.request,
            singleUseCustomerToken: nil,
            paymentHandleTokenFrom: nil,
            applePay: options.applePay?.request,
            paypal: nil
        )
    }

    func payPalPaymentRequest(from options: PSPayPalTokenizeOptions) -> PaymentRequest {
        PaymentRequest(
            merchantRefNum: options.merchantRefNum,
            transactionType: options.transactionType.request,
            card: nil,
            accountId: options.accountId,
            paymentType: .payPal,
            amount: options.amount,
            currencyCode: options.currencyCode,
            returnLinks: [
                ReturnLink(
                    rel: .defaultAction,
                    href: baseHref,
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onCompleted,
                    href: "\(baseHref)success",
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onFailed,
                    href: "\(baseHref)failed",
                    method: "GET"
                ),
                ReturnLink(
                    rel: .onCancelled,
                    href: "\(baseHref)cancelled",
                    method: "GET"
                )
            ],
            profile: options.profile?.request,
            threeDs: nil,
            billingDetails: options.billingDetails?.request,
            merchantDescriptor: options.merchantDescriptor?.request,
            shippingDetails: options.shippingDetails?.request,
            singleUseCustomerToken: nil,
            paymentHandleTokenFrom: nil,
            applePay: nil,
            paypal: options.paypal?.request
        )
    }

    /// Return card object with details for saved card payment or new card payment.
    ///
    /// - Parameters:
    ///   - card: CardRequest
    ///   - isNewCard: Boolean indicating if a new card is used
    func cardDetails(
        using card: CardRequest?,
        isNewCard: Bool
    ) -> CardRequest? {
        guard let card else { return nil }
        return isNewCard ? card : CardRequest(cvv: card.cvv, holderName: card.holderName)
    }

    /// Handle payment response.
    ///
    /// - Parameters:
    ///   - paymentResponse: Payment response
    func handlePaymentResponse(
        using paymentResponse: PaymentResponse,
        process: Bool?
    ) -> AnyPublisher<PaymentHandle, PSError> {
        let paymentHandle = PaymentHandle(
            accountId: paymentResponse.accountId,
            merchantRefNum: paymentResponse.merchantRefNum,
            paymentHandleToken: paymentResponse.paymentHandleToken,
            redirectPaymentLink: paymentResponse.links?.first { $0.rel == .redirectPayment },
            returnLinks: paymentResponse.returnLinks,
            orderId: paymentResponse.gatewayResponse?.id
        )
        // Publish paymentHandleResponse directly in PayPal flow
        if paymentResponse.paymentType == .payPal {
            return Just(paymentHandle).setFailureType(to: PSError.self).eraseToAnyPublisher()
        }
        // Publish paymentHandleResponse directly in Apple Pay flow
        if paymentResponse.applePay != nil {
            return Just(paymentHandle).setFailureType(to: PSError.self).eraseToAnyPublisher()
        }
        // Handle the payment response before publishing the paymentHandleResponse in Card payments flow
        return handleCardPaymentResponse(
            using: paymentResponse,
            process: process
        )
        .map { _ in paymentHandle }
        .eraseToAnyPublisher()
    }

    /// Handle card payment response.
    ///
    /// - Parameters:
    ///   - paymentResponse: Payment response
    func handleCardPaymentResponse(
        using paymentResponse: PaymentResponse,
        process: Bool?
    ) -> AnyPublisher<Void, PSError> {
        guard let cardBin = paymentResponse.card?.networkToken?.bin ?? paymentResponse.card?.cardBin else {
            return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId))
                .eraseToAnyPublisher()
        }
        /// We prioritize the accountId received from the response. If the response comes with a nil value we use the
        /// accountId provided in the Tokenizable object.
        let availableAccountId = paymentResponse.accountId ?? accountId
        guard let availableAccountId else {
            return Fail(error: .coreInvalidAccountId(
                PaysafeSDK.shared.correlationId,
                message: "Invalid account id for \(PaymentType.card.rawValue)."
            ))
            .eraseToAnyPublisher()
        }

        let threeDSOptions = Paysafe3DSOptions(
            accountId: availableAccountId,
            bin: cardBin
        )
        return paysafe3DS.initiate3DSFlow(
            using: threeDSOptions,
            and: getSupportedUI(from: renderType)
        )
        .flatMap { [weak self] deviceFingerprintingId -> AnyPublisher<AuthenticationResponse, PSError> in
            guard let self,
                  let id = paymentResponse.id else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            let challengePayloadOptions = ChallengePayloadOptions(
                id: id,
                merchantRefNum: paymentResponse.merchantRefNum,
                process: process
            )
            return getChallengePayload(
                using: challengePayloadOptions,
                and: deviceFingerprintingId
            )
        }
        .flatMap { [weak self] authenticationResponse -> AnyPublisher<Void, PSError> in
            guard let self,
                  let id = paymentResponse.id else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return handleAuthenticationResponse(
                using: authenticationResponse,
                and: id
            )
        }
        .flatMap { [weak self] _ -> AnyPublisher<Void, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return refreshPaymentToken(
                using: paymentResponse.paymentHandleToken
            )
        }
        .eraseToAnyPublisher()
    }

    /// Get challenge payload.
    ///
    /// - Parameters:
    ///   - options: ChallengePayloadOptions
    ///   - deviceFingerprintingId: Device fingerprinting id
    func getChallengePayload(
        using options: ChallengePayloadOptions,
        and deviceFingerprintingId: String
    ) -> AnyPublisher<AuthenticationResponse, PSError> {
        let authenticationRequest = AuthenticationRequest(
            deviceFingerprintingId: deviceFingerprintingId,
            merchantRefNum: options.merchantRefNum,
            process: options.process
        )
        let getChallengePayloadUrl = environment.baseURL + "/cardadapter/v1/paymenthandles/\(options.id)/authentications"
        return networkingService.request(
            url: getChallengePayloadUrl,
            httpMethod: .post,
            payload: authenticationRequest
        )
        .mapError { $0.toPSError(PaysafeSDK.shared.correlationId) }
        .eraseToAnyPublisher()
    }

    /// Handle authentication response.
    ///
    /// - Parameters:
    ///   - response: AuthenticationResponse
    ///   - paymentHandleId: Payment handle id
    func handleAuthenticationResponse(
        using response: AuthenticationResponse,
        and paymentHandleId: String
    ) -> AnyPublisher<Void, PSError> {
        switch response.status {
        case .completed:
            return Just(()).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .pending:
            return handlePendingAuthenticationStatus(
                using: response.sdkChallengePayload,
                and: paymentHandleId
            )
        case .failed:
            let error = PSError.corePaymentHandleCreationFailed(
                PaysafeSDK.shared.correlationId,
                message: "Status of the payment handle is \(response.status)"
            )
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    /// Handle pending authentication status.
    ///
    /// - Parameters:
    ///   - challengePayload: Challenge payload
    ///   - paymentHandleId: Payment handle id
    func handlePendingAuthenticationStatus(
        using challengePayload: String?,
        and paymentHandleId: String
    ) -> AnyPublisher<Void, PSError> {
        paysafe3DS.startChallenge(
            using: challengePayload
        )
        .flatMap { [weak self] authenticationId -> AnyPublisher<FinalizeResponse, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return finalizePaymentHandle(
                using: paymentHandleId,
                and: authenticationId
            )
        }
        .flatMap { [weak self] finalizeResponse -> AnyPublisher<Void, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return handleFinalizeResponse(
                using: finalizeResponse
            )
        }
        .eraseToAnyPublisher()
    }

    /// Finalize payment handle.
    ///
    /// - Parameters:
    ///   - paymentHandleId: Payment handle id
    ///   - authenticationId: Authentication id
    func finalizePaymentHandle(
        using paymentHandleId: String,
        and authenticationId: String
    ) -> AnyPublisher<FinalizeResponse, PSError> {
        let finalizeUrl = environment.baseURL + "/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/\(authenticationId)/finalize"
        return networkingService.request(
            url: finalizeUrl,
            httpMethod: .post,
            payload: EmptyRequest()
        )
        .mapError { $0.toPSError(PaysafeSDK.shared.correlationId) }
        .eraseToAnyPublisher()
    }

    /// Handle finalize response status.
    ///
    /// - Parameters:
    ///   - response: FinalizeResponse
    func handleFinalizeResponse(
        using response: FinalizeResponse
    ) -> AnyPublisher<Void, PSError> {
        switch response.status {
        case .completed:
            return Just(()).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .pending:
            return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        case .failed:
            let error = PSError.corePaymentHandleCreationFailed(
                PaysafeSDK.shared.correlationId,
                message: "Status of the payment handle is \(response.status)"
            )
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    /// Get payment handle token status.
    ///
    /// - Parameters:
    ///   - paymentHandleToken: Payment handle token
    func getPaymentHandleTokenStatus(
        using paymentHandleToken: String
    ) -> AnyPublisher<RefreshPaymentHandleTokenResponse, PSError> {
        let refreshPaymentHandleTokenRequest = RefreshPaymentHandleTokenRequest(paymentHandleToken: paymentHandleToken)
        let getPaymentHandleStatusUrl = environment.baseURL + "/paymenthub/v1/singleusepaymenthandles/search"
        return networkingService.request(
            url: getPaymentHandleStatusUrl,
            httpMethod: .post,
            payload: refreshPaymentHandleTokenRequest
        )
        .mapError { $0.toPSError(PaysafeSDK.shared.correlationId) }
        .eraseToAnyPublisher()
    }

    /// Handle refresh payment handle token response status.
    ///
    /// - Parameters:
    ///   - response: RefreshPaymentHandleTokenResponse
    ///   - retryCount: Number of retry attempts
    ///   - delayInSeconds: Delay between retries
    func handleRefreshPaymentHandleTokenResponse(
        using response: RefreshPaymentHandleTokenResponse,
        and retryCount: Int,
        and delayInSeconds: TimeInterval
    ) -> AnyPublisher<Void, PSError> {
        print("[Payment token refresh] STATUS \(response.status.rawValue)")
        switch response.status {
        case .payable:
            logEvent("Payment Handle Tokenize function call.")
            return Just(()).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .completed, .initiated, .processing:
            guard retryCount > 0 else {
                let error = PSError.corePaymentHandleCreationFailed(
                    PaysafeSDK.shared.correlationId,
                    message: "Status of the payment handle is \(response.status)"
                )
                return Fail(error: error).eraseToAnyPublisher()
            }
            return retryRefreshPaymentToken(
                using: response.paymentHandleToken,
                and: retryCount,
                and: delayInSeconds
            )
        case .failed, .expired:
            let error = PSError.corePaymentHandleCreationFailed(
                PaysafeSDK.shared.correlationId,
                message: "Status of the payment handle is \(response.status)"
            )
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    /// Retry refresh payment token after delay.
    ///
    /// - Parameters:
    ///   - paymentHandleToken: Payment handle token
    ///   - retryCount: Number of retry attempts
    ///   - delayInSeconds: Delay between retries
    func retryRefreshPaymentToken(
        using paymentHandleToken: String,
        and retryCount: Int,
        and delayInSeconds: TimeInterval
    ) -> AnyPublisher<Void, PSError> {
        Future { promise in
            // Skip delay in unit tests
            guard NSClassFromString("XCTest") == nil else { return promise(.success(())) }
            DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds) {
                promise(.success(()))
            }
        }
        .flatMap { [weak self] _ -> AnyPublisher<Void, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return refreshPaymentToken(
                using: paymentHandleToken,
                and: retryCount - 1
            )
        }
        .eraseToAnyPublisher()
    }

    /// Maps the render type chosen by the merchant and returns the ThreeDS supported ui.
    func getSupportedUI(from renderType: RenderType?) -> Paysafe3DS.SupportedUI? {
        guard let renderType else { return nil }
        switch renderType {
        case .native:
            return .native
        case .html:
            return .html
        case .both:
            return .both
        }
    }

    /// Determines if unit tests are being performed.
    func performsUnitTests() -> Bool {
        NSClassFromString("XCTest") != nil
    }
}
// swiftlint:enable file_length
