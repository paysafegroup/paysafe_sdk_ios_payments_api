//
//  PSError+Custom.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

// swiftlint:disable line_length
// MARK: - API errors
public extension PSError {
    static func genericAPIError(
        _ correlationId: String,
        message: String,
        code: Int
    ) -> PSError {
        PSError(
            errorCode: .genericAPIError,
            correlationId: correlationId,
            code: code,
            detailedMessage: message
        )
    }

    static func genericAPIError(_ correlationId: String? = nil) -> PSError {
        PSError(
            errorCode: .genericAPIError,
            correlationId: correlationId ?? "N/A",
            code: 9014,
            detailedMessage: "Unhandled error occurred."
        )
    }

    static func invalidResponse(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .invalidResponse,
            correlationId: correlationId ?? "N/A",
            code: 9002,
            detailedMessage: serverCommunicationErrorMessage
        )
    }

    static func threeDSInvalidResponse(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSInvalidResponse,
            correlationId: correlationId,
            code: 9002,
            detailedMessage: serverCommunicationErrorMessage
        )
    }

    static func invalidURL(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .invalidURL,
            correlationId: correlationId ?? "N/A",
            code: 9168,
            detailedMessage: serverCommunicationErrorMessage
        )
    }

    static func threeDSInvalidURL(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSInvalidURL,
            correlationId: correlationId,
            code: 9168,
            detailedMessage: serverCommunicationErrorMessage
        )
    }

    static func encodingError(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .encodingError,
            correlationId: correlationId ?? "N/A",
            code: 9205,
            detailedMessage: "Encoding error."
        )
    }

    static func threeDSEncodingError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSEncodingError,
            correlationId: correlationId,
            code: 9205,
            detailedMessage: "Encoding error."
        )
    }

    static func timeoutError(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .timeoutError,
            correlationId: correlationId ?? "N/A",
            code: 9204,
            detailedMessage: "Timeout error."
        )
    }

    static func noConnectionToServer(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .noConnectionToServer,
            correlationId: correlationId,
            code: 9001,
            detailedMessage: "No connection to server."
        )
    }
}

// MARK: - Core errors
public extension PSError {
    static func coreInvalidAPIKey(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreInvalidAPIKey,
            correlationId: correlationId,
            code: 9167,
            detailedMessage: "The API key should not be empty."
        )
    }

    static func coreInvalidAPIKeyFormat(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreInvalidAPIKeyFormat,
            correlationId: correlationId,
            code: 9013,
            detailedMessage: "Invalid API key."
        )
    }

    static func coreUnavailableEnvironment(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreUnavailableEnvironment,
            correlationId: correlationId,
            code: 9203,
            detailedMessage: "The PROD environment cannot be used in a simulator, emulator, rooted or jailbroken devices."
        )
    }

    static func coreSDKInitializeError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreSDKInitializeError,
            correlationId: correlationId,
            code: 9202,
            detailedMessage: "Application context not initialized!"
        )
    }

    static func coreMerchantAccountConfigurationError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreMerchantAccountConfigurationError,
            correlationId: correlationId,
            code: 9073,
            detailedMessage: "Account not configured correctly."
        )
    }

    static func coreInvalidCurrencyCode(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreInvalidCurrencyCode,
            correlationId: correlationId,
            code: 9055,
            detailedMessage: "Invalid currency parameter."
        )
    }

    static func corePaymentHandleCreationFailed(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .corePaymentHandleCreationFailed,
            correlationId: correlationId,
            code: 9131,
            detailedMessage: message
        )
    }

    static func coreInvalidAccountId(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .coreInvalidAccountId,
            correlationId: correlationId,
            code: 9061,
            detailedMessage: message
        )
    }

    static func coreFailedToFetchAvailablePayments(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreFailedToFetchAvailablePayments,
            correlationId: correlationId,
            code: 9084,
            detailedMessage: "Failed to load available payment methods."
        )
    }

    static func coreThreeDSAuthenticationRejected(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreThreeDSAuthenticationRejected,
            correlationId: correlationId,
            code: 9040,
            detailedMessage: "Authentication result is not accepted for the provided account."
        )
    }

    static func coreTokenizationAlreadyInProgress(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreTokenizationAlreadyInProgress,
            correlationId: correlationId,
            code: 9136,
            detailedMessage: "Tokenization is already in progress."
        )
    }

    static func coreAPIInvalidCardDetails(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreAPIInvalidCardDetails,
            correlationId: correlationId,
            code: 9003,
            detailedMessage: "You submitted an invalid card number or brand or combination of card number and brand with your request."
        )
    }
}

// MARK: - 3DS errors
public extension PSError {
    static func threeDSFailedValidation(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSFailedValidation,
            correlationId: correlationId,
            code: 9201,
            detailedMessage: "JWT is not validated."
        )
    }

    static func threeDSUserCancelled(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSUserCancelled,
            correlationId: correlationId,
            code: 9200,
            detailedMessage: "User cancelled 3DS challenge."
        )
    }

    static func threeDSTimeout(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSTimeout,
            correlationId: correlationId,
            code: 9199,
            detailedMessage: "3DS challenge timeout."
        )
    }

    static func threeDSSessionFailure(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .threeDSSessionFailure,
            correlationId: correlationId,
            code: 9198,
            detailedMessage: message
        )
    }

    static func threeDSChallengePayloadError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSChallengePayloadError,
            correlationId: correlationId,
            code: 9197,
            detailedMessage: "Unable to process challenge payload."
        )
    }

    static func threeDSInvalidCurrencyCode(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSInvalidCurrency,
            correlationId: correlationId,
            code: 9055,
            detailedMessage: "Invalid currency parameter."
        )
    }

    static func threeDSInvalidApiKeyParameter(_ correlationId: String
    ) -> PSError {
        PSError(
            errorCode: .threeDSInvalidApiKey,
            correlationId: correlationId,
            code: 9013,
            detailedMessage: "Invalid apiKey parameter."
        )
    }
}

// MARK: - Apple Pay errors
public extension PSError {
    static func applePayNotSupported(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .applePayNotSupported,
            correlationId: correlationId,
            code: 9086,
            detailedMessage: "The device does not support the payment methods, the user has no active card in the wallet, or the merchant domain is not validated with Apple."
        )
    }

    static func applePayUserCancelled(_ correlationId: String? = nil) -> PSError {
        PSError(
            errorCode: .applePayUserCancelled,
            correlationId: correlationId ?? "N/A",
            code: 9042,
            detailedMessage: "User aborted authentication."
        )
    }
}

// MARK: - Venmo errors
public extension PSError {
    static func venmoFailedAuthorization(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .venmoFailedAuthorization,
            correlationId: correlationId,
            code: 9291,
            detailedMessage: "Venmo failed authorization."
        )
    }

    static func venmoUserCancelled(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .venmoUserCancelled,
            correlationId: correlationId,
            code: 9195,
            detailedMessage: "User cancelled Venmo flow."
        )
    }
    
    static func venmoAppNotFound(_ correlationId: String? = nil) -> PSError {
        PSError(
            errorCode: .venmoAppIsNotInstalled,
            correlationId: correlationId ?? "N/A",
            code: 9197,
            detailedMessage: "Venmo App Doesn't exist."
        )
    }
}

// MARK: - PSCardForm errors
public extension PSError {
    static func invalidCardFields(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .invalidCardFields,
            correlationId: correlationId,
            code: 9003,
            detailedMessage: message
        )
    }

    static func invalidAccountIdFormat(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidAccountIdFormat,
            correlationId: correlationId,
            code: 9101,
            detailedMessage: "Invalid accountId parameter."
        )
    }

    static func noAvailablePayments(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .noAvailablePayments,
            correlationId: correlationId,
            code: 9085,
            detailedMessage: "There are no available payment methods for this API key."
        )
    }

    static func unsuportedCardBrand(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .unsuportedCardBrand,
            correlationId: correlationId,
            code: 9125,
            detailedMessage: "Unsupported card brand used."
        )
    }

    static func invalidAmount(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidAmount,
            correlationId: correlationId,
            code: 9054,
            detailedMessage: "Amount should be a number greater than 0 no longer than 11 characters."
        )
    }

    static func threeDSInvalidAmount(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSInvalidAmount,
            correlationId: correlationId,
            code: 9054,
            detailedMessage: "Amount should be a number greater than 0 no longer than 11 characters."
        )
    }

    static func invalidDynamicDescriptor(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidDynamicDescriptor,
            correlationId: correlationId,
            code: 9098,
            detailedMessage: "Invalid parameter in merchantDescriptor.dynamicDescriptor."
        )
    }

    static func invalidPhone(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidPhone,
            correlationId: correlationId,
            code: 9099,
            detailedMessage: "Invalid parameter in merchantDescriptor.phone."
        )
    }

    static func invalidFirstName(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidFirstName,
            correlationId: correlationId,
            code: 9112,
            detailedMessage: "Profile firstName should be valid."
        )
    }

    static func invalidLastName(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidLastName,
            correlationId: correlationId,
            code: 9113,
            detailedMessage: "Profile lastName should be valid."
        )
    }

    static func invalidEmail(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidEmail,
            correlationId: correlationId,
            code: 9119,
            detailedMessage: "Profile email should be valid."
        )
    }

    static func threeDSInvalidCountryParameter(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSInvalidCountry,
            correlationId: correlationId,
            code: 9068,
            detailedMessage: "Invalid country parameter."
        )
    }
}
// swiftlint:enable line_length
