//
//  PSApplePayContext.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PassKit
import PaysafeApplePay
import PaysafeCommon

/// PSApplePayContext
public class PSApplePayContext {
    /// Paysafe API client
    var psAPIClient: PSAPIClient? = PaysafeSDK.shared.psAPIClient
    /// PSApplePay
    var psApplePay: PSApplePay
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()
    /// Boolean value indicating if Apple Pay is supported
    static var isApplePaySupported: Bool = false

    /// PSApplePayContext private initializer.
    ///
    /// - Parameters:
    ///   - merchantIdentifier: Merchant identifier
    ///   - countryCode: Country code
    ///   - supportedNetworks: Supported payment networks
    private init(
        merchantIdentifier: String,
        countryCode: String,
        supportedNetworks: Set<SupportedNetwork>
    ) {
        psApplePay = PSApplePay(
            merchantIdentifier: merchantIdentifier,
            countryCode: countryCode,
            supportedNetworks: supportedNetworks
        )
    }

    /// Initializes the PSApplePayContext.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - merchantIdentifier: Merchant identifier
    ///   - countryCode: Country code
    ///   - completion: PSApplePayContextInitializeBlock
    public static func initialize(
        currencyCode: String,
        accountId: String,
        merchantIdentifier: String,
        countryCode: String,
        completion: @escaping PSApplePayContextInitializeBlock
    ) {
        validatePaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId,
            merchantIdentifier: merchantIdentifier,
            countryCode: countryCode,
            completion: completion
        )
    }

    /// PaysafeCore ApplePay tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSApplePayTokenizeOptions
    ///   - completion: PSTokenizeBlock
    public func tokenize(
        using options: PSApplePayTokenizeOptions,
        completion: @escaping PSTokenizeBlock
    ) {
        guard let psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        /// Validate Apple Pay tokenize options
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

    /// Returns a `PSApplePayButtonView` if Apple Pay is supported, nil otherwise.
    ///
    /// - Parameters:
    ///   - type: Apple Pay button type
    ///   - style: Apple Pay button style
    ///   - action: Apple Pay button action closure
    public func applePayButton(
        type: PSApplePayButtonView.ButtonType,
        style: PSApplePayButtonView.ButtonStyle,
        action: (() -> Void)?
    ) -> PSApplePayButtonView {
        PSApplePayButtonView(
            buttonType: type,
            buttonStyle: style,
            action: action
        )
    }

    /// Returns a `PSApplePayButtonSwiftUIView` if Apple Pay is supported, nil otherwise.
    ///
    /// - Parameters:
    ///   - type: Apple Pay button type
    ///   - style: Apple Pay button style
    ///   - action: Apple Pay button action closure
    public func applePaySwiftUIButton(
        type: PSApplePayButtonView.ButtonType,
        style: PSApplePayButtonView.ButtonStyle,
        action: (() -> Void)?
    ) -> PSApplePayButtonSwiftUIView {
        PSApplePayButtonSwiftUIView(
            buttonType: type,
            buttonStyle: style,
            action: action
        )
    }
}

// MARK: - Private
private extension PSApplePayContext {
    /// Validates the payment method based on `currencyCode` and `accountId`.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - merchantIdentifier: Merchant identifier
    ///   - countryCode: Country code
    ///   - completion: PSApplePayContextInitializeBlock
    static func validatePaymentMethod(
        currencyCode: String,
        accountId: String,
        merchantIdentifier: String,
        countryCode: String,
        completion: @escaping PSApplePayContextInitializeBlock
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
        guard accountId.containsOnlyNumbers else {
            let error = PSError.invalidAccountIdFormat(PaysafeSDK.shared.correlationId)
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
                    merchantIdentifier: merchantIdentifier,
                    countryCode: countryCode,
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
    ///   - merchantIdentifier: Merchant identifier
    ///   - countryCode: Country code
    ///   - completion: PSApplePayContextInitializeBlock
    static func handlePaymentMethodSupport(
        paymentMethod: PaymentMethod,
        merchantIdentifier: String,
        countryCode: String,
        completion: @escaping PSApplePayContextInitializeBlock
    ) {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        let isPaymentMethodSupported = paymentMethod.paymentMethod == .card && paymentMethod.accountConfiguration?.isApplePay == true
        switch isPaymentMethodSupported {
        case true:
            handleApplePaySupport(
                paymentMethod: paymentMethod,
                merchantIdentifier: merchantIdentifier,
                countryCode: countryCode,
                completion: completion
            )
        case false:
            let error = PSError.coreInvalidAccountId(
                PaysafeSDK.shared.correlationId,
                message: "Invalid account id for Apple Pay."
            )
            psAPIClient.logEvent(error)
            completion(.failure(error))
        }
    }

    /// Handles Apple Pay support.
    ///
    /// - Parameters:
    ///   - paymentMethod: Payment method
    ///   - merchantIdentifier: Merchant identifier
    ///   - countryCode: Country code
    ///   - completion: PSApplePayContextInitializeBlock
    static func handleApplePaySupport(
        paymentMethod: PaymentMethod,
        merchantIdentifier: String,
        countryCode: String,
        completion: @escaping PSApplePayContextInitializeBlock
    ) {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        let supportedNetworks = getSupportedNetworksFrom(
            paymentMethod.accountConfiguration?.cardTypeConfig
        )
        isApplePaySupported = PKPaymentAuthorizationController.canMakePayments()
        switch isApplePaySupported {
        case true:
            psAPIClient.logEvent(
                "Options passed on PSApplePayContext initialize: merchantIdentifier: \(merchantIdentifier), " +
                    "countryCode: \(countryCode), " +
                    "supportedNetworks: \(Set(supportedNetworks.map(\.network.rawValue)))"
            )
            let applePayContext = PSApplePayContext(
                merchantIdentifier: merchantIdentifier,
                countryCode: countryCode,
                supportedNetworks: supportedNetworks
            )
            completion(.success(applePayContext))
        case false:
            let error = PSError.applePayNotSupported(PaysafeSDK.shared.correlationId)
            psAPIClient.logEvent(error)
            completion(.failure(error))
        }
    }

    /// Get supported networks from CardTypeConfig.
    ///
    /// - Parameters:
    ///   - cardTypeConfig: CardTypeConfig
    static func getSupportedNetworksFrom(_ cardTypeConfig: CardTypeConfig?) -> Set<SupportedNetwork> {
        Set(
            cardTypeConfig?.compactMap { type, availableCapability in
                guard let cardType = AuthenticationCardType(rawValue: type),
                      let capability = CardTypeOption(rawValue: availableCapability.uppercased()) else { return nil }
                return SupportedNetwork(
                    network: cardType.toPKPaymentNetwork(),
                    capability: capability
                )
            } ?? []
        )
    }

    /// PaysafeCore ApplePay tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSApplePayTokenizeOptions
    func tokenize(
        using options: PSApplePayTokenizeOptions
    ) -> AnyPublisher<String, PSError> {
        psApplePay.initiateApplePayFlow(
            currencyCode: options.currencyCode,
            amount: options.amount / 100,
            psApplePay: options.psApplePay
        )
        .setFailureType(to: PSError.self)
        .flatMap { [weak self] applePayResult -> AnyPublisher<ApplePaymentResponse, PSError> in
            guard let self else { return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher() }
            return handleApplePayResult(
                using: applePayResult,
                and: options
            )
        }
        .map { applePaymentResponse in
            // Signal Apple Pay success completion
            applePaymentResponse.completion?(.success, nil)
            return applePaymentResponse.paymentHandleToken
        }
        .eraseToAnyPublisher()
    }

    /// Handle Apple Pay result.
    ///
    /// - Parameters:
    ///   - result: Apple Pay result
    ///   - options: PSApplePayTokenizeOptions
    func handleApplePayResult(
        using result: Result<InitializeApplePayResponse, PSError>,
        and options: PSApplePayTokenizeOptions
    ) -> AnyPublisher<ApplePaymentResponse, PSError> {
        guard let psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return Fail(error: .coreSDKInitializeError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }
        switch result {
        case let .success(initializeApplePayResponse):
            return handleInitializeApplePayResponse(
                using: initializeApplePayResponse,
                and: options
            )
        case let .failure(error):
            psAPIClient.logEvent(error)
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    /// Handle initialize Apple Pay response.
    ///
    /// - Parameters:
    ///   - response: InitializeApplePayResponse
    ///   - options: PSApplePayTokenizeOptions
    func handleInitializeApplePayResponse(
        using response: InitializeApplePayResponse,
        and options: PSApplePayTokenizeOptions
    ) -> AnyPublisher<ApplePaymentResponse, PSError> {
        guard let psAPIClient else {
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
            applePay: ApplePayAdditionalData(
                label: "Pay with Apple",
                requestBillingAddress: false,
                applePayPaymentToken: applePayTokenRequest(
                    using: response.applePayPaymentToken.token
                )
            )
        )
        return psAPIClient.tokenize(
            options: tokenizeOptions,
            paymentType: .card
        )
        .catch { error -> AnyPublisher<PaymentHandle, PSError> in
            // Signal Apple Pay failure completion
            response.completion?(.failure, error)
            return Fail(error: error).eraseToAnyPublisher()
        }
        .map {
            ApplePaymentResponse(
                paymentHandleToken: $0.paymentHandleToken,
                completion: response.completion
            )
        }
        .eraseToAnyPublisher()
    }

    /// Returns Apple Pay token request based on Apple Pay token.
    ///
    /// - Parameters:
    ///   - applePayToken: Apple Pay token
    func applePayTokenRequest(
        using applePayToken: ApplePayToken
    ) -> ApplePayPaymentTokenRequest {
        ApplePayPaymentTokenRequest(
            token: ApplePayTokenRequest(
                paymentData: applePayToken.paymentData.map { paymentData in
                    ApplePaymentDataRequest(
                        signature: paymentData.signature,
                        data: paymentData.data,
                        header: ApplePaymentHeaderRequest(
                            publicKeyHash: paymentData.header.publicKeyHash,
                            ephemeralPublicKey: paymentData.header.ephemeralPublicKey,
                            transactionId: paymentData.header.transactionId
                        ),
                        version: paymentData.version
                    )
                },
                paymentMethod: ApplePaymentMethodRequest(
                    displayName: applePayToken.paymentMethod.displayName,
                    network: applePayToken.paymentMethod.network,
                    type: applePayToken.paymentMethod.type
                ),
                transactionIdentifier: applePayToken.transactionIdentifier
            )
        )
    }

    /// Check if Apple Pay tokenize options are valid.
    ///
    /// - Parameters:
    ///   - options: PSApplePayTokenizeOptions
    func validateTokenizeOptions(_ options: PSApplePayTokenizeOptions) -> PSError? {
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
