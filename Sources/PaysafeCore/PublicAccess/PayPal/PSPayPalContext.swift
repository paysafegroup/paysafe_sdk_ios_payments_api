//
//  PSPayPalContext.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation
import PaysafeCommon
import PaysafePayPal

/// PSPayPalContext
public class PSPayPalContext {
    /// Paysafe API client
    var psAPIClient: PSAPIClient? = PaysafeSDK.shared.psAPIClient
    /// PSPayPal
    var psPayPal: PSPayPal
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()

    /// PSPayPalContext private initializer.
    ///
    /// - Parameters:
    ///   - clientId: PayPal client id
    private init(
        clientId: String
    ) {
        psPayPal = PSPayPal(
            renderType: .native(
                clientId: clientId,
                environment: psAPIClient?.environment.toPayPalEnvironment() ?? .sandbox
            )
        )
    }

    /// Initializes the PSPayPalContext.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - completion: PSPayPalContextInitializeBlock
    public static func initialize(
        currencyCode: String,
        accountId: String,
        completion: @escaping PSPayPalContextInitializeBlock
    ) {
        validatePaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId,
            completion: completion
        )
    }

    /// PaysafeCore PayPal tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSPayPalTokenizeOptions
    ///   - completion: PSTokenizeBlock
    public func tokenize(
        using options: PSPayPalTokenizeOptions,
        completion: @escaping PSTokenizeBlock
    ) {
        guard let psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        /// Validate PayPal tokenize options
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
}

// MARK: - Private
private extension PSPayPalContext {
    /// Validates the payment method based on `currencyCode` and `accountId`.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - completion: PSPayPalContextInitializeBlock
    static func validatePaymentMethod(
        currencyCode: String,
        accountId: String,
        completion: @escaping PSPayPalContextInitializeBlock
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
    ///   - completion: PSPayPalContextInitializeBlock
    static func handlePaymentMethodSupport(
        paymentMethod: PaymentMethod,
        currencyCode: String,
        accountId: String,
        completion: @escaping PSPayPalContextInitializeBlock
    ) {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        let isPaymentMethodSupported = paymentMethod.paymentMethod == .payPal
        switch isPaymentMethodSupported {
        case true:
            psAPIClient.logEvent(
                "Options passed on PSPayPalContext initialize: countryCode: \(currencyCode), accountId: \(accountId)"
            )
            #warning("Retrieve clientId from account configuration when available")
            let clientId = "AYl_LoVRWK8Pm3JnCBG1IO1iNc0cG86KFARp5c6XFneeeTocdBWdmG0sCOFdshVms-ptnoK_ChfmCeCJ"
            let payPalContext = PSPayPalContext(clientId: clientId)
            completion(.success(payPalContext))
        case false:
            let error = PSError.coreInvalidAccountId(
                PaysafeSDK.shared.correlationId,
                message: "Invalid account id for \(paymentMethod.paymentMethod)"
            )
            psAPIClient.logEvent(error)
            completion(.failure(error))
        }
    }

    /// PaysafeCore PayPal tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSPayPalTokenizeOptions
    func tokenize(
        using options: PSPayPalTokenizeOptions
    ) -> AnyPublisher<String, PSError> {
        guard let psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return Fail(error: .coreSDKInitializeError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }
        let tokenizeOptions = PSTokenizeOptions(
            amount: options.amount,
            currencyCode: options.currencyCode,
            transactionType: .payment,
            merchantRefNum: options.merchantRefNum,
            customerDetails: CustomerDetails(
                billingDetails: options.customerDetails.billingDetails,
                profile: nil
            ),
            accountId: options.accountId,
            paypal: PayPalAdditionalData(
                consumerId: options.consumerId,
                recipientDescription: options.recipientDescription,
                language: options.language,
                shippingPreference: options.shippingPreference,
                consumerMessage: options.consumerMessage,
                orderDescription: options.orderDescription,
                recipientType: .payPalId
            )
        )
        return psAPIClient.tokenize(
            options: tokenizeOptions,
            paymentType: .payPal
        )
        .flatMap { [weak self] paymentHandle -> AnyPublisher<(PaymentHandle, PSPayPalResult), PSError> in
            guard let self else { return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher() }
            return handleTokenizeResponse(
                using: paymentHandle
            )
        }
        .flatMap { result -> AnyPublisher<String, PSError> in
            let (paymentHandle, payPalResult) = result
            switch payPalResult {
            case .success:
                return psAPIClient.refreshPaymentToken(
                    using: paymentHandle.paymentHandleToken
                )
                .map { _ in paymentHandle.paymentHandleToken }
                .eraseToAnyPublisher()
            case .failed:
                return Fail(error: .payPalFailedAuthorization(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            case .cancelled:
                return Fail(error: .payPalUserCancelled(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
        }
        .catch { [weak self] error -> AnyPublisher<String, PSError> in
            self?.psAPIClient?.logEvent(error)
            return Fail(error: error).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    /// Handle tokenize response.
    ///
    /// - Parameters:
    ///   - paymentHandle: PaymentHandle
    func handleTokenizeResponse(
        using paymentHandle: PaymentHandle
    ) -> AnyPublisher<(PaymentHandle, PSPayPalResult), PSError> {
        guard let orderId = paymentHandle.orderId,
              let redirectUrl = paymentHandle.redirectPaymentLink?.href,
              let successUrl = paymentHandle.returnLinks.first(where: { $0.rel == .onCompleted })?.href,
              let failedUrl = paymentHandle.returnLinks.first(where: { $0.rel == .onFailed })?.href,
              let cancelledUrl = paymentHandle.returnLinks.first(where: { $0.rel == .onCancelled })?.href,
              let defaultUrl = paymentHandle.returnLinks.first(where: { $0.rel == .defaultAction })?.href else {
            return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }
        let payPalLinks = PSPayPalLinks(
            redirectUrl: redirectUrl,
            successUrl: successUrl,
            failedUrl: failedUrl,
            cancelledUrl: cancelledUrl,
            defaultUrl: defaultUrl
        )
        return psPayPal.initiatePayPalFlow(
            orderId: orderId,
            payPalLinks: payPalLinks
        )
        .map { payPalResult in (paymentHandle, payPalResult) }
        .eraseToAnyPublisher()
    }

    /// Check if PayPal tokenize options are valid.
    ///
    /// - Parameters:
    ///   - options: PSPayPalTokenizeOptions
    func validateTokenizeOptions(_ options: PSPayPalTokenizeOptions) -> PSError? {
        guard PSTokenizeOptionsUtils.isValidAmount(options.amount) else {
            return PSError.invalidAmount(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidEmail(options.customerDetails.profile?.email) else {
            return PSError.invalidEmail(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidFirstName(options.customerDetails.profile?.firstName) else {
            return PSError.invalidFirstName(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidLastName(options.customerDetails.profile?.lastName) else {
            return PSError.invalidLastName(PaysafeSDK.shared.correlationId)
        }
        return nil
    }
}
