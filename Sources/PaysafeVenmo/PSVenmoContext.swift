//
//  PSVenmoContext.swift
//
//
//  Created by Eduardo Oliveros on 5/28/24.
//

import Foundation
import Combine
import UIKit

#if canImport(PaysafeCommon)
@_exported import PaysafeCommon
#endif
#if canImport(BraintreeCore)
import BraintreeCore
#else
import Braintree
#endif

/// Paysafe Venmo context initialize block.
public typealias PSVenmoContextInitializeBlock = (Result<PSVenmoContext, PSError>) -> Void

/// PSVenmoContext
public class PSVenmoContext {
    
    /// Paysafe API client
    var psAPIClient: PSAPIClient? = PaysafeSDK.shared.psAPIClient
    /// PSVenmo
    var psVenmo: PSVenmo
    /// Currency converter
    private let currencyConverter = CurrencyConverter(
        conversionRules: CurrencyConverter.defaultCurrenciesMap()
    )
    
    /// The URL scheme to return to this app after switching to another app or opening a SFSafariViewController.
    /// This URL scheme must be registered as a URL Type in the app's info.plist, and it must start with the app's bundle ID.
    static var returnURLScheme: String = ""
    
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the PSVenmoContext.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - completion: PSVenmoContextInitializeBlock
    public static func initialize(
        currencyCode: String,
        accountId: String,
        completion: @escaping PSVenmoContextInitializeBlock
    ) {
        validatePaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId,
            completion: completion
        )
    }
    
    public static func setURLScheme(scheme: String) {
        self.returnURLScheme = scheme
        BTAppContextSwitcher.sharedInstance.returnURLScheme = scheme
    }
    
    public static func setURLContexts(contexts urlContexts: Set<UIOpenURLContext>) {
        urlContexts.forEach { context in
            if context.url.scheme?.localizedCaseInsensitiveCompare(returnURLScheme) == .orderedSame {
                _ = BTAppContextSwitcher.sharedInstance.handleOpenURL(context: context)
            }
        }
    }
    
    ///
    /// - Parameters:
    ///   - clientId: Venmo client id
    public init() {
        psVenmo = PSVenmo()
    }
    
    /// Handle tokenize response.
    ///
    /// - Parameters:
    ///   - paymentHandle: PaymentHandle
    func handleTokenizeResponse(
        using paymentHandle: PaymentHandle,
        amount: Int
    ) -> AnyPublisher<(PaymentHandle, PSVenmoResult), PSError> {
        switch paymentHandle.status {
        case .initiated, .processing:
            if paymentHandle.action == "REDIRECT" {
                guard let clientToken = paymentHandle.gatewayResponse?.clientToken,
                      let sessionToken = paymentHandle.gatewayResponse?.sessionToken else {
                    return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
                }
                psVenmo.configureClient(clientId: clientToken)
                return venmoFlow(using: sessionToken, amount: amount).map { result in
                    if result {
                        return (paymentHandle, PSVenmoResult.success)
                    } else {
                        return (paymentHandle, PSVenmoResult.failed)
                    }
                }.eraseToAnyPublisher()
            }
        case .payable:
            return Just((paymentHandle, .success)).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .failed, .expired:
            return Fail(error: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        default:
            return Just((paymentHandle, .failed)).setFailureType(to: PSError.self).eraseToAnyPublisher()
        }
        return Just((paymentHandle, .failed)).setFailureType(to: PSError.self).eraseToAnyPublisher()
    }
    
    func venmoFlow(using jwtToken: String, amount: Int) -> AnyPublisher<Bool, PSError> {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return Fail(error: .coreSDKInitializeError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }
        return psVenmo.initiateVenmoFlow(
            profileId: jwtToken,
            amount: amount
        )
        .flatMap { venmoResult -> AnyPublisher<Bool, PSError> in
            switch venmoResult {
            case .success(let venmoAccount):
                return psAPIClient.updatePaymentNonce(
                    using: venmoAccount,
                    jwtToken: jwtToken)
            case .failed:
                return Fail(error: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            case .cancel:
                return psAPIClient.venmoCanceledRequest(jwtToken: jwtToken)
            }
        }
        .eraseToAnyPublisher()
    }
    /// PaysafeCore Venmo tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSVenmoTokenizeOptions
    ///   - completion: PSTokenizeBlock
    public func tokenize(
        using options: PSVenmoTokenizeOptions,
        completion: @escaping PSTokenizeBlock
    ) {
        guard let psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        /// Validate Venmo tokenize options
        if let error = validateTokenizeOptions(options) {
            psAPIClient.logEvent(error)
            return completion(.failure(error))
        }
        tokenize(
            using: options
        )
        .sink { publisherCompletion in
            switch publisherCompletion {
            case .finished:
                break
            case let .failure(error):
                completion(.failure(error))
            }
        } receiveValue: { paymentHandleToken in
            completion(.success(paymentHandleToken))
        }
        .store(in: &cancellables)
    }
    
    /// Check if Venmo tokenize options are valid.
    ///
    /// - Parameters:
    ///   - options: PSVenmoTokenizeOptions
    public func validateTokenizeOptions(_ options: PSVenmoTokenizeOptions) -> PSError? {
        guard PSTokenizeOptionsUtils.isValidAmount(options.amount) else {
            return PSError.invalidAmount(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidFirstName(options.profile?.firstName) else {
            return PSError.invalidFirstName(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidLastName(options.profile?.lastName) else {
            return PSError.invalidLastName(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidEmail(options.profile?.email) else {
            return PSError.invalidEmail(PaysafeSDK.shared.correlationId)
        }
        return nil
    }
}

//// MARK: - Private
private extension PSVenmoContext {
    
    /// PaysafeCore Venmo tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSVenmoTokenizeOptions
    func tokenize(
        using options: PSVenmoTokenizeOptions
    ) -> AnyPublisher<String, PSError> {
        guard let psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return Fail(error: .coreSDKInitializeError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }
        return psAPIClient.tokenize(
            options: options,
            paymentType: .venmo
        )
        .flatMap { [weak self] paymentHandle -> AnyPublisher<(PaymentHandle, PSVenmoResult), PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return handleTokenizeResponse(using: paymentHandle, amount: options.amount)
        }
        .flatMap { result -> AnyPublisher<String, PSError> in
            let (paymentHandle, _) = result
            return psAPIClient.refreshPaymentToken(
                using: paymentHandle.paymentHandleToken
            )
            .map { _ in paymentHandle.paymentHandleToken }
            .eraseToAnyPublisher()
        }
        .catch { [weak self] error -> AnyPublisher<String, PSError> in
            self?.psAPIClient?.logEvent(error)
            return Fail(error: error).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    /// Validates the payment method based on `currencyCode` and `accountId`.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - completion: PSVenmoContextInitializeBlock
    static func validatePaymentMethod(
        currencyCode: String,
        accountId: String,
        completion: @escaping PSVenmoContextInitializeBlock
    ) {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        guard currencyCode.isThreeLetterCharacterString else {
            let error = PSError.coreInvalidCurrencyCode(PaysafeSDK.shared.correlationId)
            psAPIClient.logEvent(error)
            return completion(.failure(error))
        }
        psAPIClient.getPaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId
        ) { result in
            switch result {
            case let .success(paymentMethod):
                handlePaymentMethodSupport(
                    paymentMethod: paymentMethod,
                    currencyCode: currencyCode,
                    accountId: accountId,
                    completion: completion
                )
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    /// Handles payment method support.
    ///
    /// - Parameters:
    ///   - paymentMethod: Payment method
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - completion: PSVenmoContextInitializeBlock
    static func handlePaymentMethodSupport(
        paymentMethod: PaymentMethod,
        currencyCode: String,
        accountId: String,
        completion: @escaping PSVenmoContextInitializeBlock
    ) {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        let isPaymentMethodSupported = paymentMethod.paymentMethod == .venmo
        switch isPaymentMethodSupported {
        case true:
            psAPIClient.logEvent(
                "Options passed on PSVenmoContext initialize: currency code: \(currencyCode), accountId: \(accountId)"
            )
            let venmoContext = PSVenmoContext()
            completion(.success(venmoContext))
        case false:
            let error = PSError.coreInvalidAccountId(
                PaysafeSDK.shared.correlationId,
                message: "Invalid account id for \(paymentMethod.paymentMethod)"
            )
            psAPIClient.logEvent(error)
            completion(.failure(error))
        }
    }
}

public extension PSAPIClient {
    /// update PaymentNonce
    ///
    /// - Parameters:
    ///   - venmoAccount: Venmo account information
    ///   - jwtToken: JWT Token
    ///
    func updatePaymentNonce(using venmoAccount: VenmoAccount, jwtToken: String) -> AnyPublisher<Bool, PSError> {
        let paymentMethodNonce = venmoAccount.nonce
        let paymentMethodDeviceData = "{\"correlation_id\": \"" + networkingService.correlationId + "\"}"
        let detailsRequest = BraintreeDetailsRequest(
            paymentMethodJwtToken: jwtToken,
            paymentMethodNonce: paymentMethodNonce,
            paymentMethodDeviceData: paymentMethodDeviceData,
            errorCode: 0,
            paymentMethodPayerInfo: venmoAccount.serialize()
        )

        guard var urlComps = URLComponents(string: environment.baseURL + "/alternatepayments/venmo/v1/hostedSession/braintreeDetails") else {
            return Fail(error: .venmoFailedAuthorization(networkingService.correlationId)).eraseToAnyPublisher()
        }
        let queryItems = [URLQueryItem(name: "payment_method_nonce", value: detailsRequest.paymentMethodNonce),
                          URLQueryItem(name: "payment_method_payerInfo", value: venmoAccount.serialize()),
                          URLQueryItem(name: "payment_method_jwtToken", value: detailsRequest.paymentMethodJwtToken),
                          URLQueryItem(name: "payment_method_deviceData", value: detailsRequest.paymentMethodDeviceData),
                          URLQueryItem(name: "errorCode", value: "")]

        urlComps.queryItems = queryItems
        guard let sendPaymentNonceUrl = urlComps.url?.absoluteString else {
            return Fail(error: .venmoFailedAuthorization(networkingService.correlationId)).eraseToAnyPublisher()
        }

        logEvent("/braintreeDetails endpoint called with: \(sendPaymentNonceUrl)")

        return networkingService.request(
            url: sendPaymentNonceUrl,
            httpMethod: .get,
            payload: EmptyRequest()
        )
        .mapError { [weak self] error in
            self?.logEvent(error.localizedDescription)
            return PSError.venmoFailedAuthorization(
                self?.networkingService.correlationId ?? PaysafeSDK.shared.correlationId
            )
        }
        .eraseToAnyPublisher()
    }

    /// Venmo CanceledRequest
    ///
    /// - Parameters:
    ///   - jwtToken: JWT Token
    ///
    ///

    func venmoCanceledRequest(jwtToken: String) -> AnyPublisher<Bool, PSError> {
        let paymentMethodDeviceData = "{\"correlation_id\": \"" + networkingService.correlationId + "\"}"

        guard var urlComps = URLComponents(string: environment.baseURL + "/alternatepayments/venmo/v1/hostedSession/braintreeDetails") else {
            return Fail(error: .venmoFailedAuthorization(networkingService.correlationId)).eraseToAnyPublisher()
        }
        let queryItems = [URLQueryItem(name: "payment_method_nonce", value: ""),
                          URLQueryItem(name: "payment_method_payerInfo", value: ""),
                          URLQueryItem(name: "payment_method_jwtToken", value: jwtToken),
                          URLQueryItem(name: "payment_method_deviceData", value: paymentMethodDeviceData),
                          URLQueryItem(name: "errorCode", value: "VENMO_CANCELED")]

        urlComps.queryItems = queryItems
        guard let sendPaymentNonceUrl = urlComps.url?.absoluteString else {
            return Fail(error: .venmoFailedAuthorization(networkingService.correlationId)).eraseToAnyPublisher()
        }

        return networkingService.request(
            url: sendPaymentNonceUrl,
            httpMethod: .get,
            payload: EmptyRequest()
        )
        .tryMap { value in
            if value {
                return false
            }
            throw PSError.venmoFailedAuthorization(self.networkingService.correlationId)
        }
        .mapError { [weak self] error in
            self?.logEvent(error.localizedDescription)
            return PSError.venmoFailedAuthorization(self?.networkingService.correlationId)
        }
        .eraseToAnyPublisher()
    }
}
