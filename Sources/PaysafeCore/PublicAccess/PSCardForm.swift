//
//  PSCardForm.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import SwiftUI
#if canImport(PaysafeCommon)
@_exported import PaysafeCommon
#endif
#if canImport(Paysafe3DS)
import Paysafe3DS
#endif

/// PSCardForm. The PSCardForm class is responsable for handling the 3D Secure authentication in a seamless way.
/// Its main responsability is to present the UI elements, capture and manipulate card details and tokenizing the card details.
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
public class PSCardForm {
    /// Paysafe API client
    var psAPIClient: PSAPIClient? = PaysafeSDK.shared.psAPIClient
    /// 3DS client
    var paysafe3DS: Paysafe3DS?
    /// Card number UIView that merchants can use to capture the card's PAN.
    /// This data is hidden from the merchant and only the sdk can manipulate or send the data to the paysafe backend.
    let cardNumberView: PSCardNumberInputView?
    /// Cardholder name UIView that merchants can use to capture the card's holder name.
    /// This data is hidden from the merchant and only the sdk can manipulate or send the data to the paysafe backend.
    let cardholderNameView: PSCardholderNameInputView?
    /// Card expiry UIView that merchants can use to capture the card's expiry date.
    /// This data is hidden from the merchant and only the sdk can manipulate or send the data to the paysafe backend.
    let cardExpiryView: PSCardExpiryInputView?
    /// Card CVV UIView that merchants can use to capture the card's cvv.
    /// This data is hidden from the merchant and only the sdk can manipulate or send the data to the paysafe backend.
    let cardCVVView: PSCardCVVInputView?
    /// Supported card networks
    private static var supportedNetworks: Set<PSCardBrand> = []
    
    /// Card form update event
    public var onCardFormUpdate: PSCardFormUpdateBlock?
    /// Card brand recognition event
    public var onCardBrandRecognition: PSCardBrandBlock?
    /// Cancellables set
    private var cancellables = Set<AnyCancellable>()
    
    /// PSCardForm private initializer.
    ///
    /// - Parameters:
    ///   - cardNumberView: PSCardNumberInputView
    ///   - cardholderNameView: PSCardholderNameInputView
    ///   - cardExpiryView: PSCardExpiryInputView
    ///   - cardCVVView: PSCardCVVInputView
    private init(
        cardNumberView: PSCardNumberInputView?,
        cardholderNameView: PSCardholderNameInputView?,
        cardExpiryView: PSCardExpiryInputView?,
        cardCVVView: PSCardCVVInputView?
    ) {
        self.cardNumberView = cardNumberView
        self.cardholderNameView = cardholderNameView
        self.cardExpiryView = cardExpiryView
        self.cardCVVView = cardCVVView
        if let psAPIClient {
            self.paysafe3DS = Paysafe3DS(apiKey: psAPIClient.apiKey, environment: psAPIClient.environment.to3DSEnvironment())
        }
        setupDelegates()
        logInitializedFields()
    }

    /// Initializes the PSCardForm using SwiftUI components.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - cardNumberSwiftUIView: PSCardNumberInputSwiftUIView
    ///   - cardholderNameSwiftUIView: PSCardholderNameInputSwiftUIView
    ///   - cardExpirySwiftUIView: PSCardExpiryInputSwiftUIView
    ///   - cardCVVSwiftUIView: PSCardCVVInputSwiftUIView
    ///   - completion: PSCardFormInitializeBlock
    public static func initialize(
        currencyCode: String,
        accountId: String,
        cardNumberSwiftUIView: PSCardNumberInputSwiftUIView? = nil,
        cardholderNameSwiftUIView: PSCardholderNameInputSwiftUIView? = nil,
        cardExpirySwiftUIView: PSCardExpiryInputSwiftUIView? = nil,
        cardCVVSwiftUIView: PSCardCVVInputSwiftUIView? = nil,
        completion: @escaping PSCardFormInitializeBlock
    ) {
        validatePaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId,
            cardNumberView: cardNumberSwiftUIView?.cardNumberView,
            cardholderNameView: cardholderNameSwiftUIView?.cardholderNameView,
            cardExpiryView: cardExpirySwiftUIView?.cardExpiryView,
            cardCVVView: cardCVVSwiftUIView?.cardCVVView,
            completion: completion
        )
    }

    /// Initializes the PSCardForm using UIKit components.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - cardNumberView: PSCardNumberInputView
    ///   - cardholderNameView: PSCardholderNameInputView
    ///   - cardExpiryView: PSCardExpiryInputView
    ///   - cardCVVView: PSCardCVVInputView
    ///   - completion: PSCardFormInitializeBlock
    public static func initialize(
        currencyCode: String,
        accountId: String,
        cardNumberView: PSCardNumberInputView? = nil,
        cardholderNameView: PSCardholderNameInputView? = nil,
        cardExpiryView: PSCardExpiryInputView? = nil,
        cardCVVView: PSCardCVVInputView? = nil,
        completion: @escaping PSCardFormInitializeBlock
    ) {
        validatePaymentMethod(
            currencyCode: currencyCode,
            accountId: accountId,
            cardNumberView: cardNumberView,
            cardholderNameView: cardholderNameView,
            cardExpiryView: cardExpiryView,
            cardCVVView: cardCVVView,
            completion: completion
        )
    }

    /// This tokenize function returns a completion, which will resolve to a single-use payment handle representing the user's sensitive card data.
    /// This handle can be used by the Payments API to take payments. Single-use handles are valid for only 15 minutes and are not consumed by verification.
    ///
    /// - Note: PSTokenizeOptions
    /// * amount: Payment amount in minor units
    /// * transactionType: Transaction type
    /// * paymentType: Payment type
    /// * merchantRefNum: Merchant reference number
    /// * merchantDescriptor: Merchant descriptor
    /// * accountId: Account id
    /// * threeDS: ThreeDS
    /// * applePay: Apple Pay additional data
    /// * singleUseCustomerToken: Single use customer token
    /// * paymentTokenFrom: Payment token from
    /// - Parameters:
    ///   - options: PSTokenizeOptions
    ///   - completion: PSTokenizeBlock
    public func tokenize(
        using options: PSCardTokenizeOptions,
        completion: @escaping PSTokenizeBlock
    ) {
        guard let psAPIClient else {
            assertionFailure(.uninitializedSDKMessage)
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        guard let card = retrieveCardInformation() else {
            let error = PSError.invalidCardFields(
                PaysafeSDK.shared.correlationId,
                message: "Invalid fields: \(getInvalidFields())"
            )
            psAPIClient.logEvent(error)
            return completion(.failure(error))
        }
        
        /// Validate tokenize options
        if let error = validateTokenizeOptions(options) {
            psAPIClient.logEvent(error)
            return completion(.failure(error))
        }
        psAPIClient.tokenize(
            options: options,
            paymentType: .card,
            card: card
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] publisherCompletion in
            self?.resetCardDetails()
            switch publisherCompletion {
            case .finished:
                break
            case let .failure(error):
                completion(.failure(error))
            }
        } receiveValue: { paymentHandleResponse in
            guard let paysafe3DS = self.paysafe3DS else {
                return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
            }
            
            psAPIClient
                .handleCardPaymentResponse(using: paymentHandleResponse, process: options.threeDS?.process, paysafe3DS: paysafe3DS)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] publisherCompletion in
                    self?.resetCardDetails()
                    switch publisherCompletion {
                    case .finished: break
                    case let .failure(error): completion(.failure(error))
                    }
                } receiveValue: { paymentHandleResponse in completion(.success(paymentHandleResponse)) }
                .store(in: &self.cancellables)
        }
        .store(in: &cancellables)
    }
}

// MARK: - Public helper methods
extension PSCardForm {
    /// Resets all text fields.
    public func resetCardDetails() {
        cardNumberView?.reset()
        cardholderNameView?.reset()
        cardExpiryView?.reset()
        cardCVVView?.reset()
    }

    /// Checks form validation state.
    public func areAllFieldsValid() -> Bool {
        let isCardNumberValid = cardNumberView?.isValid() ?? true
        let isCardholderNameValid = cardholderNameView?.isValid() ?? true
        let isCardExpiryValid = cardExpiryView?.isValid() ?? true
        let isCardCVVValid = cardCVVView?.isValid() ?? true
        return isCardNumberValid && isCardholderNameValid && isCardExpiryValid && isCardCVVValid
    }

    /// Checks card brand.
    public func getCardBrand() -> PSCardBrand {
        let cardBrand = cardNumberView?.cardNumberTextField.cardBrand ?? cardCVVView?.cardCVVTextField.cardBrand
        return cardBrand ?? .unknown
    }
}

// MARK: - Private
private extension PSCardForm {
    /// Validates the payment method based on `currencyCode` and `accountId`.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - accountId: Account id
    ///   - cardNumberView: PSCardNumberInputView
    ///   - cardholderNameView: PSCardholderNameInputView
    ///   - cardExpiryView: PSCardExpiryInputView
    ///   - cardCVVView: PSCardCVVInputView
    ///   - completion: PSCardFormInitializeBlock
    static func validatePaymentMethod(
        currencyCode: String,
        accountId: String,
        cardNumberView: PSCardNumberInputView?,
        cardholderNameView: PSCardholderNameInputView?,
        cardExpiryView: PSCardExpiryInputView?,
        cardCVVView: PSCardCVVInputView?,
        completion: @escaping PSCardFormInitializeBlock
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
                    cardNumberView: cardNumberView,
                    cardholderNameView: cardholderNameView,
                    cardExpiryView: cardExpiryView,
                    cardCVVView: cardCVVView,
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
    ///   - cardNumberView: PSCardNumberInputView
    ///   - cardholderNameView: PSCardholderNameInputView
    ///   - cardExpiryView: PSCardExpiryInputView
    ///   - cardCVVView: PSCardCVVInputView
    ///   - completion: PSCardFormInitializeBlock
    static func handlePaymentMethodSupport(
        paymentMethod: PaymentMethod,
        cardNumberView: PSCardNumberInputView?,
        cardholderNameView: PSCardholderNameInputView?,
        cardExpiryView: PSCardExpiryInputView?,
        cardCVVView: PSCardCVVInputView?,
        completion: @escaping PSCardFormInitializeBlock
    ) {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        let isPaymentMethodSupported = paymentMethod.paymentMethod == .card
        switch isPaymentMethodSupported {
        case true:
            handleNetworksSupport(
                paymentMethod: paymentMethod,
                cardNumberView: cardNumberView,
                cardholderNameView: cardholderNameView,
                cardExpiryView: cardExpiryView,
                cardCVVView: cardCVVView,
                completion: completion
            )
        case false:
            let error = PSError.coreInvalidAccountId(
                PaysafeSDK.shared.correlationId,
                message: "Invalid account id for \(paymentMethod.paymentMethod)."
            )
            psAPIClient.logEvent(error)
            completion(.failure(error))
        }
    }

    /// Handles networks support.
    ///
    /// - Parameters:
    ///   - paymentMethod: Payment method
    ///   - cardNumberView: PSCardNumberInputView
    ///   - cardholderNameView: PSCardholderNameInputView
    ///   - cardExpiryView: PSCardExpiryInputView
    ///   - cardCVVView: PSCardCVVInputView
    ///   - completion: PSCardFormInitializeBlock
    static func handleNetworksSupport(
        paymentMethod: PaymentMethod,
        cardNumberView: PSCardNumberInputView?,
        cardholderNameView: PSCardholderNameInputView?,
        cardExpiryView: PSCardExpiryInputView?,
        cardCVVView: PSCardCVVInputView?,
        completion: @escaping PSCardFormInitializeBlock
    ) {
        guard let psAPIClient = PaysafeSDK.shared.psAPIClient else {
            return completion(.failure(.coreSDKInitializeError(PaysafeSDK.shared.correlationId)))
        }
        supportedNetworks = getSupportedNetworksFrom(
            paymentMethod.accountConfiguration?.cardTypeConfig
        )
        switch supportedNetworks.isEmpty {
        case false:
            let cardForm = PSCardForm(
                cardNumberView: cardNumberView,
                cardholderNameView: cardholderNameView,
                cardExpiryView: cardExpiryView,
                cardCVVView: cardCVVView
            )
            completion(.success(cardForm))
        case true:
            let error = PSError.noAvailablePayments(PaysafeSDK.shared.correlationId)
            psAPIClient.logEvent(error)
            completion(.failure(error))
        }
    }

    /// Get supported networks from CardTypeConfig.
    ///
    /// - Parameters:
    ///   - cardTypeConfig: CardTypeConfig
    static func getSupportedNetworksFrom(_ cardTypeConfig: CardTypeConfig?) -> Set<PSCardBrand> {
        Set(
            cardTypeConfig?.compactMap {
                AuthenticationCardType(rawValue: $0.key)?.toPSCardBrand()
            } ?? []
        )
    }

    /// Retrieves card information from custom textfields
    func retrieveCardInformation() -> CardRequest? {
        guard let cardholderName = cardholderNameView?.cardholderNameTextField.cardholderNameValue,
              let cardCVV = cardCVVView?.cardCVVTextField.cardCVVValue else { return nil }
        let card = CardRequest(
            cardNum: cardNumberView?.cardNumberTextField.cardNumberValue,
            cardExpiry: CardExpiryRequest(
                month: cardExpiryView?.cardExpiryTextField.cardExpiryDateValue?.month,
                year: cardExpiryView?.cardExpiryTextField.cardExpiryDateValue?.year
            ),
            cvv: cardCVV,
            holderName: cardholderName,
            cardType: nil,
            nickName: nil
        )
        return card
    }

    /// Configures component delegates
    func setupDelegates() {
        cardNumberView?.psDelegate = self
        cardholderNameView?.psDelegate = self
        cardExpiryView?.psDelegate = self
        cardCVVView?.psDelegate = self
    }

    /// Logs initialized fields
    func logInitializedFields() {
        let fields: [String: PSCardInputView?] = [
            "cardNumber": cardNumberView,
            "cardHolderName": cardholderNameView,
            "expiryDate": cardExpiryView,
            "security(CVV/CVC)": cardCVVView
        ]
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let fieldDetails = fields
                .compactMap { key, customView -> String? in
                    guard let placeholder = customView?.getPlaceholder() else { return nil }
                    return "\"\(key)\":{\"placeholder\":\"\(placeholder)\",\"accessibilityLabel\":\"\(placeholder)\", \"accessibilityErrorMessage\": N/A}"
                }
                .joined(separator: ", ")
            psAPIClient?.logEvent("Initialized fields: {\(fieldDetails)}")
        }
    }

    /// Get invalid fields
    func getInvalidFields() -> String {
        let fields: [String: PSCardInputView?] = [
            "cardNumber": cardNumberView,
            "cardHolderName": cardholderNameView,
            "expiryDate": cardExpiryView,
            "security(CVV/CVC)": cardCVVView
        ]
        let fieldDetails = fields
            .compactMap { key, customView in
                customView?.isValid() == false ? key : nil
            }
            .joined(separator: ", ")
        return fieldDetails
    }

    /// Check if tokenize options are valid.
    ///
    /// - Parameters:
    ///   - options: PSTokenizeOptions
    func validateTokenizeOptions(_ options: PSCardTokenizeOptions) -> PSError? {
        guard PSCardForm.supportedNetworks.contains(getCardBrand()) else {
            return PSError.unsuportedCardBrand(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidAmount(options.amount) else {
            return PSError.invalidAmount(PaysafeSDK.shared.correlationId)
        }
        guard PSTokenizeOptionsUtils.isValidDynamicDescriptor(options.merchantDescriptor?.dynamicDescriptor) else {
            return PSError.invalidDynamicDescriptor(PaysafeSDK.shared.correlationId)
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
        guard PSTokenizeOptionsUtils.isValidPhone(options.merchantDescriptor?.phone) else {
            return PSError.invalidPhone(PaysafeSDK.shared.correlationId)
        }
        return nil
    }
}

// MARK: - PSCardNumberInputViewDelegate
extension PSCardForm: PSCardNumberInputViewDelegate {
    func didUpdateCardNumberInputValidationState(isValid: Bool) {
        onCardFormUpdate?(isValid ? areAllFieldsValid() : false)
    }

    func didUpdateCardBrand(with cardBrand: PSCardBrand) {
        cardCVVView?.cardCVVTextField.cardBrand = cardBrand
        onCardBrandRecognition?(cardBrand)
    }
}

// MARK: - PSCardholderNameInputViewDelegate
extension PSCardForm: PSCardholderNameInputViewDelegate {
    func didUpdateCardholderNameInputValidationState(isValid: Bool) {
        onCardFormUpdate?(isValid ? areAllFieldsValid() : false)
    }
}

// MARK: - PSCardExpiryInputViewDelegate
extension PSCardForm: PSCardExpiryInputViewDelegate {
    func didUpdateCardExpiryInputValidationState(isValid: Bool) {
        onCardFormUpdate?(isValid ? areAllFieldsValid() : false)
    }
}

// MARK: - PSCardCVVInputViewDelegate
extension PSCardForm: PSCardCVVInputViewDelegate {
    func didUpdateCardCVVInputValidationState(isValid: Bool) {
        onCardFormUpdate?(isValid ? areAllFieldsValid() : false)
    }
}
