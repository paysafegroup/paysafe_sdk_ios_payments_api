//
//  PSVenmoContext.swift
//
//
//  Created by Eduardo Oliveros on 5/28/24.
//

import Foundation
import PaysafeCommon
import PaysafeVenmo
import BraintreeCore
import Combine
import UIKit

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
        BTAppContextSwitcher.sharedInstance.returnURLScheme = scheme
    }
    
    public static func setURLContexts(contexts urlContexts: Set<UIOpenURLContext>) {
        urlContexts.forEach { context in
            if context.url.scheme?.localizedCaseInsensitiveCompare("com.paysafe.LotteryTicket-dev.payments") == .orderedSame {
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
                      let jwtToken = paymentHandle.gatewayResponse?.jwtToken else {
                    return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
                }
                psVenmo.configureClient(clientId: clientToken)
                return venmoFlow(using: jwtToken, amount: amount).map { result in
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
                return Fail(error: PSError.venmoUserCancelled(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
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
        guard PSTokenizeOptionsUtils.isValidEmail(options.profile?.email) else {
            return PSError.invalidEmail(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidFirstName(options.profile?.firstName) else {
            return PSError.invalidFirstName(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidLastName(options.profile?.lastName) else {
            return PSError.invalidLastName(PaysafeSDK.shared.correlationId)
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
            let (paymentHandle, venmoResult) = result
            switch venmoResult {
            case .success:
                return psAPIClient.refreshPaymentToken(
                          using: paymentHandle.paymentHandleToken
                        )
                        .map { _ in paymentHandle.paymentHandleToken }
                        .eraseToAnyPublisher()
            case .failed:
                return Fail(error: .venmoFailedAuthorization(PaysafeSDK.shared.correlationId))
                    .eraseToAnyPublisher()
            case .cancelled:
                return Fail(error: .venmoUserCancelled(PaysafeSDK.shared.correlationId))
                    .eraseToAnyPublisher()
            }
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
