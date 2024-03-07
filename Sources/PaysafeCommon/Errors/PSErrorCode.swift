//
//  PSErrorCode.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSErrorCode
public enum PSErrorCode {
    /// Predefined API error codes
    case genericAPIError
    case invalidResponse
    case invalidURL
    case encodingError
    case timeoutError
    case noConnectionToServer

    /// Predefined Core error codes
    case coreInvalidAPIKey
    case coreInvalidAPIKeyFormat
    case coreUnavailableEnvironment
    case coreSDKInitializeError
    case coreMerchantAccountConfigurationError
    case coreInvalidCurrencyCode
    case corePaymentHandleCreationFailed
    case coreInvalidAccountId
    case coreFailedToFetchAvailablePayments
    case coreThreeDSAuthenticationRejected
    case coreTokenizationAlreadyInProgress
    case coreAPIInvalidCardDetails

    /// Predefined 3DS error codes
    case threeDSFailedValidation
    case threeDSUserCancelled
    case threeDSTimeout
    case threeDSSessionFailure
    case threeDSChallengePayloadError
    case threeDSInvalidCountry
    case threeDSInvalidApiKey
    case threeDSInvalidAmount
    case threeDSEncodingError
    case threeDSInvalidURL
    case threeDSInvalidResponse
    case threeDSInvalidCurrency

    /// Predefined Apple Pay error codes
    case applePayNotSupported
    case applePayUserCancelled

    /// Predefined PayPal error codes
    case payPalFailedAuthorization
    case payPalUserCancelled

    /// Predefined PSCardForm error codes
    case invalidCardFields
    case invalidAccountIdFormat
    case noAvailablePayments
    case unsuportedCardBrand
    case invalidAmount
    case invalidDynamicDescriptor
    case invalidPhone
    case invalidFirstName
    case invalidLastName
    case invalidEmail

    /// PSErrorType
    public var type: PSErrorType {
        switch self {
        case .genericAPIError, .invalidResponse, .invalidURL,
             .encodingError, .timeoutError, .noConnectionToServer:
            return .apiError
        case .coreInvalidAPIKey, .coreInvalidAPIKeyFormat, .coreUnavailableEnvironment, .coreSDKInitializeError, .coreMerchantAccountConfigurationError,
             .coreInvalidCurrencyCode, .corePaymentHandleCreationFailed, .coreInvalidAccountId,
             .coreFailedToFetchAvailablePayments, .coreThreeDSAuthenticationRejected, .coreTokenizationAlreadyInProgress:
            return .coreError
        case .threeDSFailedValidation, .threeDSUserCancelled, .threeDSTimeout,
             .threeDSSessionFailure, .threeDSChallengePayloadError, .threeDSInvalidCountry, .threeDSInvalidApiKey, .coreAPIInvalidCardDetails, .threeDSInvalidAmount, .threeDSEncodingError, .threeDSInvalidURL,
             .threeDSInvalidResponse, .threeDSInvalidCurrency:
            return .threeDSError
        case .applePayNotSupported, .applePayUserCancelled:
            return .applePayError
        case .payPalFailedAuthorization, .payPalUserCancelled:
            return .payPalError
        case .invalidCardFields, .invalidAccountIdFormat, .noAvailablePayments, .unsuportedCardBrand, .invalidAmount,
             .invalidDynamicDescriptor, .invalidPhone, .invalidFirstName, .invalidLastName, .invalidEmail:
            return .cardFormError
        }
    }
}
