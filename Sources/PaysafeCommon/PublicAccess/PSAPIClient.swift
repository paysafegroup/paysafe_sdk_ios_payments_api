//
//  PSAPIClient.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation

// swiftlint:disable file_length
/// PaysafeCore module. The PaysafeCore module is responsable for initialising the PSAPIClient class and handle payment flows.
///
/// - Note: The apiKey is provided by the Paysafe Team representing a base64 encoded string.
/// - Parameters:
///   - apiKey: Paysafe API key
///   - environment: API Environment
public class PSAPIClient {
    /// PSNetworkingService
    public var networkingService: PSNetworkingService
    /// Paysafe environment
    public let environment: PaysafeEnvironment
    /// Paysafe apiKey
    public let apiKey: String
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()
    /// PSLogger
    private let logger: PSLogger
    /// Tokenize in progress flag
    private var tokenizeInProgress = false
    /// Render type used for 3ds if merchant sets a value
    public var renderType: RenderType?
    /// Account id used for current tokenize flow
    public var accountId: String?
    
    /// - Parameters:
    ///   - apiKey: Paysafe API key
    ///   - environment: Paysafe environment
    init(apiKey: String, environment: PaysafeEnvironment) {
        self.environment = environment
        self.apiKey = apiKey
        networkingService = PSNetworkingService(
            overrideSessionToBlockRedirects: true,
            authorizationKey: apiKey,
            correlationId: PaysafeSDK.shared.correlationId,
            sdkVersion: SDKConfiguration.sdkVersion
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
    public func getPaymentMethod(currencyCode: String, accountId: String, completion: @escaping PSPaymentMethodBlock) {
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
    public func tokenize(options: PSTokenizable, paymentType: PaymentType, card: CardRequest? = nil) -> AnyPublisher<PaymentHandle, PSError> {
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
                case let cardOptions as PSCardTokenizeOptions: return cardOptions.threeDS?.process
                default: return nil
                }
            }()
            return handlePaymentResponse(using: paymentResponse, process: shouldProcessTransaction)
        }
        .handleEvents(
            receiveOutput: { [weak self] _ in self?.tokenizeInProgress = false },
            receiveCompletion: { [weak self] _ in self?.tokenizeInProgress = false }
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
    public func refreshPaymentToken(using paymentHandleToken: String, and retryCount: Int = 3, and delayInSeconds: TimeInterval = 6) -> AnyPublisher<String, PSError> {
        getPaymentHandleTokenStatus(
            using: paymentHandleToken
        )
        .flatMap { [weak self] refreshPaymentHandleTokenResponse -> AnyPublisher<String, PSError> in
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
}

// MARK: - Log events
extension PSAPIClient {
    /// Log event with message.
    ///
    /// - Parameters:
    ///   - message: Message to be added to the log request
    public func logEvent(_ message: String) {
        guard !performsUnitTests() else { return }
        logger.log(eventType: .conversion, message: message)
    }
    
    /// Log event with PSError.
    ///
    /// - Parameters:
    ///   - error: Error object to be added to the log request
    public func logEvent(_ error: PSError) {
        guard !performsUnitTests() else { return }
        switch error.errorCode.type {
        case .apiError, .coreError, .applePayError, .cardFormError, .venmoError:
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
        let transactionSource = "IosSDKV2"
        
        return networkingService.request(
            url: tokenizeUrl,
            httpMethod: .post,
            payload: paymentRequest,
            invocationId: invocationId,
            transactionSource: transactionSource
        )
        .mapError {
            $0.toPSError(PaysafeSDK.shared.correlationId)
        }
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
        case let options as PSVenmoTokenizeOptions:
            return venmoPaymentRequest(from: options)
        default:
            return nil
        }
    }
    
    func cardPaymentRequest(
        from cardOptions: PSCardTokenizeOptions,
        card: CardRequest?
    ) -> PaymentRequest {
        let savedCardTokens = SavedCardTokens(
            singleUseCustomerToken: cardOptions.singleUseCustomerToken,
            paymentToken: cardOptions.paymentTokenFrom
        )
        
        return PaymentRequest(
            merchantRefNum: cardOptions.merchantRefNum,
            transactionType: cardOptions.transactionType.request,
            card: cardDetails(using: card, isNewCard: savedCardTokens == nil),
            accountId: cardOptions.accountId,
            paymentType: .card,
            amount: cardOptions.amount,
            currencyCode: cardOptions.currencyCode,
            returnLinks: PSAPIClient.returnLinks(),
            profile: cardOptions.profile?.request,
            threeDs: cardOptions.threeDS?.request(using: cardOptions.merchantRefNum),
            billingDetails: cardOptions.billingDetails?.request,
            merchantDescriptor: cardOptions.merchantDescriptor?.request,
            shippingDetails: cardOptions.shippingDetails?.request,
            singleUseCustomerToken: savedCardTokens?.singleUseCustomerToken,
            paymentHandleTokenFrom: savedCardTokens?.paymentToken,
            applePay: nil,
            venmo: nil
        )
    }
    
    func applePaymentRequest(from applePayOptions: PSApplePayTokenizeOptions) -> PaymentRequest {
        PaymentRequest(
            merchantRefNum: applePayOptions.merchantRefNum,
            transactionType: applePayOptions.transactionType.request,
            card: nil,
            accountId: applePayOptions.accountId,
            paymentType: .card,
            amount: applePayOptions.amount,
            currencyCode: applePayOptions.currencyCode,
            returnLinks: PSAPIClient.returnLinks(),
            profile: applePayOptions.profile?.request,
            threeDs: nil,
            billingDetails: applePayOptions.billingDetails?.request,
            merchantDescriptor: applePayOptions.merchantDescriptor?.request,
            shippingDetails: applePayOptions.shippingDetails?.request,
            singleUseCustomerToken: nil,
            paymentHandleTokenFrom: nil,
            applePay: applePayOptions.applePay?.request,
            venmo: nil
        )
    }
    
    func venmoPaymentRequest(from venmoOptions: PSVenmoTokenizeOptions) -> PaymentRequest {
        PaymentRequest(
            merchantRefNum: venmoOptions.merchantRefNum,
            transactionType: venmoOptions.transactionType.request,
            card: nil,
            accountId: venmoOptions.accountId,
            paymentType: .venmo,
            amount: venmoOptions.amount,
            currencyCode: venmoOptions.currencyCode,
            returnLinks: PSAPIClient.returnLinks(),
            profile: venmoOptions.profile?.request,
            threeDs: nil,
            billingDetails: venmoOptions.billingDetails?.request,
            merchantDescriptor: venmoOptions.merchantDescriptor?.request,
            shippingDetails: venmoOptions.shippingDetails?.request,
            singleUseCustomerToken: nil,
            paymentHandleTokenFrom: nil,
            applePay: nil,
            venmo: venmoOptions.venmo?.request
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
        let gatewayResponse = paymentResponse.gatewayResponse
        
        let paymentHandle = PaymentHandle(
            id: paymentResponse.id,
            accountId: paymentResponse.accountId,
            card: paymentResponse.card,
            status: PaymentHandleTokenStatus(rawValue: paymentResponse.status) ?? .failed,
            merchantRefNum: paymentResponse.merchantRefNum,
            paymentHandleToken: paymentResponse.paymentHandleToken,
            redirectPaymentLink: paymentResponse.links?.first { $0.rel == .redirectPayment },
            returnLinks: paymentResponse.returnLinks,
            orderId: paymentResponse.gatewayResponse?.id,
            gatewayResponse: gatewayResponse,
            action: paymentResponse.action
        )
        // Publish paymentHandleResponse directly in Venmo flow
        if paymentResponse.paymentType == .venmo {
            return Just(paymentHandle).setFailureType(to: PSError.self).eraseToAnyPublisher()
        }
        // Publish paymentHandleResponse directly in Apple Pay flow
        if paymentResponse.applePay != nil {
            return Just(paymentHandle).setFailureType(to: PSError.self).eraseToAnyPublisher()
        }

        return Just(paymentHandle).setFailureType(to: PSError.self).eraseToAnyPublisher()
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
    ) -> AnyPublisher<String, PSError> {
        print("[Payment token refresh] STATUS \(response.status.rawValue)")
        switch response.status {
        case .payable:
            logEvent("Payment Handle Tokenize function call.")
            return Just(response.paymentHandleToken).setFailureType(to: PSError.self).eraseToAnyPublisher()
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
    ) -> AnyPublisher<String, PSError> {
        Future { promise in
            // Skip delay in unit tests
            guard NSClassFromString("XCTest") == nil else { return promise(.success(())) }
            DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds) {
                promise(.success(()))
            }
        }
        .flatMap { [weak self] _ -> AnyPublisher<String, PSError> in
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
    
    /// Determines if unit tests are being performed.
    func performsUnitTests() -> Bool {
        NSClassFromString("XCTest") != nil
    }
    
    static func returnLinks(withReturnHref baseHref: String = "https://usgaminggamblig.com/payment/return/") -> [ReturnLink] {
        [
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
        ]
    }
}
// swiftlint:enable file_length
