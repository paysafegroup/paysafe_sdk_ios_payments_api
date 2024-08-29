//
//  PSApplePayContext.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PassKit
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

/// Paysafe Apple Pay context initialize block.
public typealias PSApplePayContextInitializeBlock = (Result<PSApplePayContext, PSError>) -> Void

/// PSApplePayContext
public class PSApplePayContext {
    /// Paysafe API client
    var psAPIClient: PSAPIClient? = PaysafeSDK.shared.psAPIClient
    /// PSApplePay
    var psApplePay: PSApplePay
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()
    /// Currency converter
    private let currencyConverter = CurrencyConverter(
        conversionRules: CurrencyConverter.defaultCurrenciesMap()
    )
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

    /// PaysafeCardPayments ApplePay tokenize method.
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

    /// PaysafeCardPayments ApplePay tokenize method.
    ///
    /// - Parameters:
    ///   - options: PSApplePayTokenizeOptions
    func tokenize(
        using options: PSApplePayTokenizeOptions
    ) -> AnyPublisher<String, PSError> {
        /// Convert amount based on currency
        let currencyCode = options.currencyCode
        let convertedAmount = convertAmount(
            using: options.amount,
            and: currencyCode
        )
        /// Initiate apple pay flow
        return psApplePay.initiateApplePayFlow(
            currencyCode: currencyCode,
            amount: convertedAmount,
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
            switch applePaymentResponse.status {
            case .payable:
                applePaymentResponse.completion?(.success, nil)
            default:
                let error = PSError.corePaymentHandleCreationFailed(
                    PaysafeSDK().correlationId,
                    message: "Status of the payment handle is \(applePaymentResponse.status)"
                )
                applePaymentResponse.completion?(.failure, error)
            }
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
        let tokenizeOptions = optionsWithApplePayData(
            from: options,
            and: response
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
                status: $0.status,
                completion: response.completion
            )
        }
        .eraseToAnyPublisher()
    }

    /// Returns Apple Pay token request based on the apple payment token..
    ///
    /// - Parameters:
    ///   - paymentToken: ApplePayPaymentToken
    func applePayTokenRequest(
        using paymentToken: ApplePayPaymentToken
    ) -> ApplePayPaymentTokenRequest {
        let token = paymentToken.token
        return ApplePayPaymentTokenRequest(
            token: ApplePayTokenRequest(
                paymentData: token.paymentData.map { paymentData in
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
                    displayName: token.paymentMethod.displayName,
                    network: token.paymentMethod.network,
                    type: token.paymentMethod.type
                ),
                transactionIdentifier: token.transactionIdentifier
            ),
            billingContact: paymentToken.billingContact
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

    /// Update options received from merchant to inclue apple pay additional data.
    private func optionsWithApplePayData(
        from options: PSApplePayTokenizeOptions,
        and response: InitializeApplePayResponse
    ) -> PSApplePayTokenizeOptions {
        var tokenizeOptions = options
        tokenizeOptions.applePay = ApplePayAdditionalData(
            label: "Pay with Apple",
            requestBillingAddress: options.psApplePay.requestBillingAddress,
            applePayPaymentToken: applePayTokenRequest(
                using: response.applePayPaymentToken
            )
        )
        return tokenizeOptions
    }

    /// Convert amount based on currency.
    private func convertAmount(
        using amount: Int,
        and currency: String
    ) -> Double {
        currencyConverter.convert(
            amount: amount,
            forCurrency: currency
        )
    }
}
