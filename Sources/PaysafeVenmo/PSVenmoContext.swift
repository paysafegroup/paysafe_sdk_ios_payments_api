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

/// Entry point for Venmo payments in the Paysafe iOS SDK.
///
/// Initialize a context with ``initialize(currencyCode:accountId:completion:)`` after the SDK is configured.
/// Call ``configureAppSwitchReturn(universalLink:returnURLScheme:)`` at app launch, then forward
/// incoming URLs with ``setURLContexts(contexts:)`` and ``openURL(url:)``.
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

    /// The Universal Link used by the Venmo app to redirect back to this app after the user
    /// authenticates in the app switch flow. Must be a valid HTTPS URL dedicated to Braintree
    /// app switch returns, with an associated domain configured for this app (via an
    /// `apple-app-site-association` file hosted on that domain).
    static var universalLink: URL?

    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()

    /// Creates a Venmo context after validating that Venmo is available for the given currency and account.
    ///
    /// The Paysafe SDK must already be initialized. On success, the completion receives a ready-to-use
    /// ``PSVenmoContext``; on failure, it receives a ``PSError``.
    ///
    /// - Parameters:
    ///   - currencyCode: Three-letter ISO currency code associated with the Venmo account.
    ///   - accountId: Account id configured for Venmo.
    ///   - completion: Called with the created context or a validation/configuration error.
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

    /// Configures the URLs used to return to this app after the Venmo app-switch flow.
    ///
    /// Call this once at app launch, before presenting Venmo. Both values are required for
    /// Braintree to complete the return from Venmo: a Universal Link for HTTPS app-switch
    /// returns, and a custom URL scheme as a fallback.
    ///
    /// - Parameters:
    ///   - universalLink: A valid HTTPS URL dedicated to Braintree app-switch returns. This domain
    ///     must be registered as an associated domain for this app (via an `apple-app-site-association`
    ///     file hosted on that domain).
    ///   - returnURLScheme: The custom URL scheme registered as a URL Type in the app's Info.plist.
    ///     It must start with the app's bundle ID.
    public static func configureAppSwitchReturn(universalLink: String, returnURLScheme: String) {
        self.universalLink = URL(string: universalLink)
        self.returnURLScheme = returnURLScheme
    }

    /// Forwards custom-scheme URL contexts from a scene or app delegate to Braintree.
    ///
    /// Call this from `scene(_:openURLContexts:)` (or `application(_:open:options:)`) so Venmo can
    /// complete the app-switch return. Contexts that are not Venmo/Braintree return URLs are ignored.
    ///
    /// - Parameter urlContexts: The URL contexts delivered by UIKit when the app is opened via a URL.
    public static func setURLContexts(contexts urlContexts: Set<UIOpenURLContext>) {
        urlContexts.forEach { context in
            if canOpenURL(url: context.url) {
                _ = BTAppContextSwitcher.sharedInstance.handleOpenURL(context: context)
            }
        }
    }

    /// Returns whether `url` is a Venmo/Braintree app-switch return URL for this app.
    ///
    /// A URL is accepted when ``configureAppSwitchReturn(universalLink:returnURLScheme:)`` has been
    /// called and either the URL path contains `braintree-payments` or the URL scheme matches the
    /// configured return URL scheme.
    ///
    /// - Parameter url: The incoming URL to evaluate.
    /// - Returns: `true` if the URL should be handled as a Venmo return; otherwise `false`.
    public static func canOpenURL(url: URL) -> Bool {
        guard !returnURLScheme.isEmpty else { return false }

        return url.path.contains("braintree-payments") || url.scheme?.localizedCaseInsensitiveCompare(returnURLScheme) == .orderedSame
    }

    /// Forwards a Universal Link (or other return URL) from a scene or app delegate to Braintree.
    ///
    /// Call this from `scene(_:continue:)` when handling `NSUserActivityTypeBrowsingWeb`. URLs that
    /// ``canOpenURL(url:)`` rejects are ignored.
    ///
    /// - Parameter url: The webpage URL from the user activity, or another Venmo return URL.
    public static func openURL(url: URL) {
        if canOpenURL(url: url) {
            _ = BTAppContextSwitcher.sharedInstance.handleOpen(url)
        }
    }

    /// Creates  Venmo context instance.
    public init() {
        psVenmo = PSVenmo()
    }

    /// Starts the Venmo payment flow and returns a single-use payment handle token.
    ///
    /// Opens Venmo (or the Venmo web fallback) for the shopper to authorize the payment. On success,
    /// the completion receives a payment handle token that can be used with the Payments API.
    ///
    /// - Parameters:
    ///   - options: Amount, account, profile, and optional Venmo-specific tokenize options.
    ///   - completion: Called with the payment handle token or a ``PSError``.
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

    /// Validates Venmo tokenize options before starting the payment flow.
    ///
    /// Checks that the amount is valid and that profile first name, last name, and email (when present)
    /// meet Paysafe requirements.
    ///
    /// - Parameter options: The tokenize options to validate.
    /// - Returns: A ``PSError`` describing the first invalid field, or `nil` if the options are valid.
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
    /// PaysafeCardPayments Venmo tokenize method.
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
            return handleTokenizeResponse(using: paymentHandle, profileId: options.venmo?.profileId, amount: options.amount)
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

    /// Routes the tokenize response by payment-handle status.
    ///
    /// Continues into the Venmo flow when a redirect is required, returns success when already
    /// payable, and maps failed or expired handles to a Venmo authorization error.
    func handleTokenizeResponse(
        using paymentHandle: PaymentHandle,
        profileId: String?,
        amount: Int
    ) -> AnyPublisher<(PaymentHandle, PSVenmoResult), PSError> {
        switch paymentHandle.status {
        case .initiated where paymentHandle.action == "REDIRECT",
            .processing where paymentHandle.action == "REDIRECT":
            return handleVenmoFlow(using: paymentHandle, profileId: profileId, amount: amount)
        case .payable:
            return Just((paymentHandle, .success)).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .failed, .expired:
            return Fail(error: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        default:
            return Just((paymentHandle, .failed)).setFailureType(to: PSError.self).eraseToAnyPublisher()
        }
    }

    /// Configures the Braintree client and continues the Venmo authorization flow.
    ///
    /// Uses the existing-customer path when a Braintree customer id is present; otherwise starts
    /// the Venmo app-switch redirect flow.
    func handleVenmoFlow(
        using paymentHandle: PaymentHandle,
        profileId: String?,
        amount: Int
    ) -> AnyPublisher<(PaymentHandle, PSVenmoResult), PSError> {
        guard let clientToken = paymentHandle.gatewayResponse?.clientToken,
              let sessionToken = paymentHandle.gatewayResponse?.sessionToken else {
            return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }

        guard let universalLink = Self.universalLink else {
            return Fail(error: .venmoInvalidUniversalLinkPassed(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }
        psVenmo.configureClient(clientToken: clientToken, universalLink: universalLink)

        if paymentHandle.gatewayResponse?.brainTreeCustomerId != nil {
            return handleExistingVenmoCustomer(using: paymentHandle, jwtToken: sessionToken)
        } else {
            return venmoRedirectFlow(
                using: sessionToken,
                profileId: profileId,
                amount: amount,
                clientMetadataId: paymentHandle.gatewayResponse?.clientMetadataId
            ).map { result in
                if result {
                    return (paymentHandle, PSVenmoResult.success)
                } else {
                    return (paymentHandle, PSVenmoResult.failed)
                }
            }.eraseToAnyPublisher()
        }
    }

    /// Completes tokenization for a payment handle that already has a Braintree customer id.
    ///
    /// Collects device data, then updates the payment nonce without launching the Venmo app switch.
    func handleExistingVenmoCustomer(
        using paymentHandle: PaymentHandle,
        jwtToken: String
    ) -> AnyPublisher<(PaymentHandle, PSVenmoResult), PSError> {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return Fail(error: .coreSDKInitializeError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }

        let clientMetadataId = paymentHandle.gatewayResponse?.clientMetadataId
        let deviceDataPublisher = psVenmo.collectDeviceData(clientMetadataId: clientMetadataId)
            .setFailureType(to: PSError.self)
            .eraseToAnyPublisher()

        return deviceDataPublisher
            .flatMap { deviceData -> AnyPublisher<(PaymentHandle, PSVenmoResult), PSError> in
                let paymentMethodDeviceData = Self.resolvedDeviceData(
                    deviceData,
                    correlationId: psAPIClient.networkingService.correlationId
                )
                return psAPIClient.updatePaymentBraintreeDetails(jwtToken: jwtToken,
                                                                 deviceData: paymentMethodDeviceData)
                    .map { result in
                        if result {
                            return (paymentHandle, PSVenmoResult.success)
                        } else {
                            return (paymentHandle, PSVenmoResult.failed)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// Runs the Venmo app-switch flow and updates the payment nonce with the result.
    ///
    /// Collects device data in parallel with Venmo authorization, then succeeds, fails, or
    /// reports cancel based on the shopper’s response.
    func venmoRedirectFlow(
        using jwtToken: String,
        profileId: String?,
        amount: Int,
        clientMetadataId: String?
    ) -> AnyPublisher<Bool, PSError> {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return Fail(error: .coreSDKInitializeError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        }

        let amountString = String(currencyConverter.convert(amount: amount, forCurrency: "USD"))
        let deviceDataPublisher: AnyPublisher<String, PSError> = psVenmo
            .collectDeviceData(clientMetadataId: clientMetadataId)
            .setFailureType(to: PSError.self)
            .eraseToAnyPublisher()

        return Publishers.Zip(
            deviceDataPublisher,
            psVenmo.initiateVenmoFlow(
                profileId: profileId,
                amount: amountString
            )
        )
        .flatMap { [weak self] deviceData, venmoResult -> AnyPublisher<Bool, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return handleVenmoRedirectResult(
                deviceData: deviceData,
                venmoResult: venmoResult,
                jwtToken: jwtToken,
                psAPIClient: psAPIClient
            )
        }
        .eraseToAnyPublisher()
    }

    /// Maps the Venmo app-switch outcome to a Braintree details or cancel request.
    func handleVenmoRedirectResult(
        deviceData: String,
        venmoResult: PSVenmoBraintreeResult,
        jwtToken: String,
        psAPIClient: PSAPIClient
    ) -> AnyPublisher<Bool, PSError> {
        let paymentMethodDeviceData = Self.resolvedDeviceData(
            deviceData,
            correlationId: psAPIClient.networkingService.correlationId
        )

        switch venmoResult {
        case .success(let venmoAccount):
            return psAPIClient.updatePaymentBraintreeDetails(
                using: venmoAccount,
                jwtToken: jwtToken,
                deviceData: paymentMethodDeviceData
            )
        case .failed:
            return Fail(error: PSError.venmoFailedAuthorization(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        case .cancel:
            return psAPIClient.venmoCanceledRequest(
                jwtToken: jwtToken,
                deviceData: paymentMethodDeviceData
            )
        }
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

    static func resolvedDeviceData(_ deviceData: String, correlationId: String) -> String {
        deviceData.isEmpty ? "{\"correlation_id\": \"\(correlationId)\"}" : deviceData
    }
}

public extension PSAPIClient {
    /// Sends Venmo details to Paysafe after authorization, or device data only for an existing Braintree customer.
    ///
    /// When `venmoAccount` is present, the request includes the payment nonce and payer info from
    /// Braintree. When it is omitted, nonce and payer info are sent empty — used when a payment
    /// handle already has a Braintree customer id and only refreshed device data is reported.
    ///
    /// - Parameters:
    ///   - venmoAccount: The Venmo account returned by Braintree, including the payment nonce.
    ///     Pass `nil` when there is no new authorization to report.
    ///   - jwtToken: Session token from the payment handle gateway response.
    ///   - deviceData: Braintree device data collected for fraud tools, or a correlation-id fallback.
    /// - Returns: A publisher that emits `true` on success, or a ``PSError`` if the request fails.
    func updatePaymentBraintreeDetails(using venmoAccount: VenmoAccount? = nil,
                                       jwtToken: String,
                                       deviceData: String) -> AnyPublisher<Bool, PSError> {
        let detailsRequest = BraintreeDetailsRequest(
            paymentMethodJwtToken: jwtToken,
            paymentMethodNonce: venmoAccount?.nonce ?? "",
            paymentMethodDeviceData: deviceData,
            errorCode: 0,
            paymentMethodPayerInfo: venmoAccount?.serialize() ?? ""
        )

        guard var urlComps = URLComponents(string: environment.baseURL + "/alternatepayments/venmo/v1/hostedSession/braintreeDetails") else {
            return Fail(error: .venmoFailedAuthorization(networkingService.correlationId)).eraseToAnyPublisher()
        }
        let queryItems = [URLQueryItem(name: "payment_method_nonce", value: detailsRequest.paymentMethodNonce),
                          URLQueryItem(name: "payment_method_payerInfo", value: detailsRequest.paymentMethodPayerInfo),
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

    /// Notifies Paysafe that the shopper canceled the Venmo app-switch flow.
    ///
    /// - Parameters:
    ///   - jwtToken: Session token from the payment handle gateway response.
    ///   - deviceData: Braintree device data collected for fraud tools, or a correlation-id fallback.
    /// - Returns: A publisher that emits `false` when the cancel is acknowledged, or a ``PSError`` on failure.
    func venmoCanceledRequest(jwtToken: String, deviceData: String) -> AnyPublisher<Bool, PSError> {
        let paymentMethodDeviceData = deviceData

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
