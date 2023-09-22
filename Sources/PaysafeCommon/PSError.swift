//
//  PSError.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSErrorCode
public enum PSErrorCode: Error {
    /// Predefined API error codes
    case genericAPIError
    case invalidResponse
    case invalidURL
    case unsuccessfulResponse
    case encodingError
    case timeoutError
    case noConnectionToServer
    case invalidCredentials
    
    /// Predefined Core error codes
    case coreInternalError
    case coreInvalidAPIKey
    case coreUnavailableEnvironment
    case coreSDKInitializeError
    case coreMerchantAccountConfigurationError
    case coreInvalidCurrencyCode
    case corePaymentHandleCreationFailed
    case coreInvalidAccountId
    case coreFailedToFetchAvailablePayments
    case coreThreeDSAuthenticationRejected
    case coreTokenizationAlreadyInProgress
    
    /// Predefined 3DS error codes
    case threeDSFailedValidation
    case threeDSInternalError
    case threeDSUserCancelled
    case threeDSTimeout
    case threeDSSessionFailure
    case threeDSChallengePayloadError
    
    /// Predefined Apple Pay error codes
    case applePayNotSupported
    case applePayUserCancelled
    
    /// Predefined PayPal error codes
    case payPalInternalError
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
    
    /// Associated name used in PSLogError.
    public var name: String {
        switch self {
        case .genericAPIError, .invalidResponse, .invalidURL, .unsuccessfulResponse,
             .encodingError, .timeoutError, .noConnectionToServer, .invalidCredentials:
            return "APIError"
        case .coreInternalError, .coreInvalidAPIKey, .coreUnavailableEnvironment, .coreSDKInitializeError,
             .coreMerchantAccountConfigurationError, .coreInvalidCurrencyCode, .corePaymentHandleCreationFailed, .coreInvalidAccountId,
             .coreFailedToFetchAvailablePayments, .coreThreeDSAuthenticationRejected, .coreTokenizationAlreadyInProgress:
            return "CoreError"
        case .threeDSFailedValidation, .threeDSInternalError, .threeDSUserCancelled,
             .threeDSTimeout, .threeDSSessionFailure, .threeDSChallengePayloadError:
            return "3DSError"
        case .applePayNotSupported, .applePayUserCancelled:
            return "ApplePayError"
        case .payPalInternalError, .payPalUserCancelled:
            return "PayPalError"
        case .invalidCardFields, .invalidAccountIdFormat, .noAvailablePayments, .unsuportedCardBrand, .invalidAmount,
             .invalidDynamicDescriptor, .invalidPhone, .invalidFirstName, .invalidLastName, .invalidEmail:
            return "CardFormError"
        }
    }
}

// swiftlint:disable type_body_length function_body_length line_length
/// PSError
public struct PSError: Error, Equatable {
    /// Error code
    public let errorCode: PSErrorCode
    /// Code
    public let code: Int
    /// Display message
    public let displayMessage: String
    /// Detailed message
    public let detailedMessage: String
    /// Correlation id
    public let correlationId: String
    
    /// - Parameters:
    ///   - errorCode: PSErrorCode
    ///   - correlationId: Correlation id
    ///   - message: ErrorMessage
    private init(
        errorCode: PSErrorCode,
        correlationId: String,
        message: String? = nil
    ) {
        self.errorCode = errorCode
        self.correlationId = correlationId
        switch errorCode {
        case .genericAPIError:
            code = 9014
            detailedMessage = "Unhandled error occurred."
        case .invalidResponse:
            code = 9002
            detailedMessage = "Error communicating with server."
        case .invalidURL:
            code = 9168
            detailedMessage = "Error communicating with server."
        case .unsuccessfulResponse:
            code = 9206
            if let message {
                detailedMessage = message
            } else {
                detailedMessage = "Error: Http Error."
            }
        case .encodingError:
            code = 9205
            detailedMessage = "Encoding error."
        case .timeoutError:
            code = 9204
            detailedMessage = "Timeout error."
        case .noConnectionToServer:
            code = 9001
            detailedMessage = "No connection to server."
        case .invalidCredentials:
            code = 9169
            detailedMessage = "Invalid credentials (API key)."
        case .coreInternalError:
            code = 9014
            detailedMessage = "Unhandled error occurred."
        case .coreInvalidAPIKey:
            code = 9167
            detailedMessage = "The API key should not be empty."
        case .coreUnavailableEnvironment:
            code = 9203
            detailedMessage = "The PROD environment cannot be used in a simulator, emulator, rooted or jailbroken devices."
        case .coreSDKInitializeError:
            code = 9202
            detailedMessage = "Application context not initialized!"
        case .coreMerchantAccountConfigurationError:
            code = 9073
            detailedMessage = "Account not configured correctly."
        case .coreInvalidCurrencyCode:
            code = 9055
            detailedMessage = "Invalid currency parameter."
        case .corePaymentHandleCreationFailed:
            code = 9131
            if let message {
                detailedMessage = message
            } else {
                detailedMessage = "Status of the payment handle is FAILED."
            }
        case .coreInvalidAccountId:
            code = 9061
            if let message {
                detailedMessage = message
            } else {
                detailedMessage = "Invalid account id for selected payment method."
            }
        case .coreFailedToFetchAvailablePayments:
            code = 9084
            detailedMessage = "Failed to load available payment methods."
        case .coreThreeDSAuthenticationRejected:
            code = 9040
            detailedMessage = "Authentication result is not accepted for the provided account."
        case .coreTokenizationAlreadyInProgress:
            code = 9136
            detailedMessage = "Tokenization is already in progress."
        case .threeDSFailedValidation:
            code = 9201
            detailedMessage = "JWT is not validated."
        case .threeDSInternalError:
            code = 9014
            detailedMessage = "Unhandled error occurred."
        case .threeDSUserCancelled:
            code = 9200
            detailedMessage = "User cancelled 3DS challenge."
        case .threeDSTimeout:
            code = 9199
            detailedMessage = "3DS challenge timeout."
        case .threeDSSessionFailure:
            code = 9198
            if let message {
                detailedMessage = message
            } else {
                detailedMessage = "ThreeDS session failed."
            }
        case .threeDSChallengePayloadError:
            code = 9197
            detailedMessage = "Unable to process challenge payload."
        case .applePayNotSupported:
            code = 9086
            detailedMessage = "The device does not support the payment methods, the user has no active card in the wallet, or the merchant domain is not validated with Apple."
        case .applePayUserCancelled:
            code = 9042
            detailedMessage = "User aborted authentication."
        case .payPalInternalError:
            code = 9196
            detailedMessage = "Unhandled error occurred."
        case .payPalUserCancelled:
            code = 9195
            detailedMessage = "User cancelled PayPal flow."
        case .invalidCardFields:
            code = 9003
            if let message {
                detailedMessage = message
            } else {
                detailedMessage = "Invalid fields."
            }
        case .invalidAccountIdFormat:
            code = 9101
            detailedMessage = "Invalid accountId parameter."
        case .noAvailablePayments:
            code = 9085
            detailedMessage = "There are no available payment methods for this API key."
        case .unsuportedCardBrand:
            code = 9125
            detailedMessage = "Unsupported card brand used."
        case .invalidAmount:
            code = 9054
            detailedMessage = "Amount should be a number greater than 0 no longer than 11 characters."
        case .invalidDynamicDescriptor:
            code = 9098
            detailedMessage = "Invalid parameter in merchantDescriptor.dynamicDescriptor."
        case .invalidPhone:
            code = 9099
            detailedMessage = "Invalid parameter in merchantDescriptor.phone."
        case .invalidFirstName:
            code = 9112
            detailedMessage = "Profile firstName should be valid."
        case .invalidLastName:
            code = 9113
            detailedMessage = "Profile lastName should be valid."
        case .invalidEmail:
            code = 9119
            detailedMessage = "Profile email should be valid."
        }
        /// Set universal display message with custom code.
        displayMessage = "There was an error (\(code)), please contact our support."
    }
    
    public static func genericAPIError(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .genericAPIError,
            correlationId: correlationId ?? "N/A"
        )
    }
    
    public static func invalidResponse(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .invalidResponse,
            correlationId: correlationId ?? "N/A"
        )
    }
    
    public static func invalidURL(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .invalidURL,
            correlationId: correlationId ?? "N/A"
        )
    }
    
    public static func unsuccessfulResponse(_ correlationId: String?, message: String) -> PSError {
        PSError(
            errorCode: .unsuccessfulResponse,
            correlationId: correlationId ?? "N/A",
            message: message
        )
    }
    
    public static func encodingError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .encodingError,
            correlationId: correlationId
        )
    }
    
    public static func timeoutError(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .timeoutError,
            correlationId: correlationId ?? "N/A"
        )
    }
    
    public static func noConnectionToServer(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .noConnectionToServer,
            correlationId: correlationId ?? "N/A"
        )
    }
    
    public static func invalidCredentials(_ correlationId: String?) -> PSError {
        PSError(
            errorCode: .invalidCredentials,
            correlationId: correlationId ?? "N/A"
        )
    }
    
    public static func coreInternalError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreInternalError,
            correlationId: correlationId
        )
    }
    
    public static func coreInvalidAPIKey(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreInvalidAPIKey,
            correlationId: correlationId
        )
    }
    
    public static func coreUnavailableEnvironment(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreUnavailableEnvironment,
            correlationId: correlationId
        )
    }
    
    public static func coreSDKInitializeError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreSDKInitializeError,
            correlationId: correlationId
        )
    }
    
    public static func coreMerchantAccountConfigurationError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreMerchantAccountConfigurationError,
            correlationId: correlationId
        )
    }
    
    public static func coreInvalidCurrencyCode(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreInvalidCurrencyCode,
            correlationId: correlationId
        )
    }
    
    public static func corePaymentHandleCreationFailed(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .corePaymentHandleCreationFailed,
            correlationId: correlationId,
            message: message
        )
    }
    
    public static func coreInvalidAccountId(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .coreInvalidAccountId,
            correlationId: correlationId,
            message: message
        )
    }
    
    public static func coreFailedToFetchAvailablePayments(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreFailedToFetchAvailablePayments,
            correlationId: correlationId
        )
    }
    
    public static func coreThreeDSAuthenticationRejected(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreThreeDSAuthenticationRejected,
            correlationId: correlationId
        )
    }
    
    public static func coreTokenizationAlreadyInProgress(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .coreTokenizationAlreadyInProgress,
            correlationId: correlationId
        )
    }
    
    public static func threeDSFailedValidation(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSFailedValidation,
            correlationId: correlationId
        )
    }
    
    public static func threeDSInternalError(_ correlationId: String = "N/A") -> PSError {
        PSError(
            errorCode: .threeDSInternalError,
            correlationId: correlationId
        )
    }
    
    public static func threeDSUserCancelled(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSUserCancelled,
            correlationId: correlationId
        )
    }
    
    public static func threeDSTimeout(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSTimeout,
            correlationId: correlationId
        )
    }
    
    public static func threeDSSessionFailure(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .threeDSSessionFailure,
            correlationId: correlationId,
            message: message
        )
    }
    
    public static func threeDSChallengePayloadError(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .threeDSChallengePayloadError,
            correlationId: correlationId
        )
    }
    
    public static func applePayNotSupported(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .applePayNotSupported,
            correlationId: correlationId
        )
    }
    
    public static func applePayUserCancelled(_ correlationId: String = "N/A") -> PSError {
        PSError(
            errorCode: .applePayUserCancelled,
            correlationId: correlationId
        )
    }
    
    public static func payPalInternalError(_ correlationId: String = "N/A") -> PSError {
        PSError(
            errorCode: .payPalInternalError,
            correlationId: correlationId
        )
    }
    
    public static func payPalUserCancelled(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .payPalUserCancelled,
            correlationId: correlationId
        )
    }
    
    public static func invalidCardFields(_ correlationId: String, message: String) -> PSError {
        PSError(
            errorCode: .invalidCardFields,
            correlationId: correlationId,
            message: message
        )
    }
    
    public static func invalidAccountIdFormat(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidAccountIdFormat,
            correlationId: correlationId
        )
    }
    
    public static func noAvailablePayments(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .noAvailablePayments,
            correlationId: correlationId
        )
    }
    
    public static func unsuportedCardBrand(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .unsuportedCardBrand,
            correlationId: correlationId
        )
    }
    
    public static func invalidAmount(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidAmount,
            correlationId: correlationId
        )
    }
    
    public static func invalidDynamicDescriptor(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidDynamicDescriptor,
            correlationId: correlationId
        )
    }
    
    public static func invalidPhone(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidPhone,
            correlationId: correlationId
        )
    }
    
    public static func invalidFirstName(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidFirstName,
            correlationId: correlationId
        )
    }
    
    public static func invalidLastName(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidLastName,
            correlationId: correlationId
        )
    }
    
    public static func invalidEmail(_ correlationId: String) -> PSError {
        PSError(
            errorCode: .invalidEmail,
            correlationId: correlationId
        )
    }
}
// swiftlint:enable type_body_length function_body_length line_length
