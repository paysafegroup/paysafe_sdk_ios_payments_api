//
//  PSErrorType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSErrorType
public enum PSErrorType: String {
    /// Predefined API error type
    case apiError = "APIError"
    /// Predefined Core error type
    case coreError = "CoreError"
    /// Predefined 3DS error type
    case threeDSError = "3DSError"
    /// Predefined Apple Pay error type
    case applePayError = "ApplePayError"
    /// Predefined PSCardForm error type
    case cardFormError = "CardFormError"
    /// Predefined Venmo error type
    case venmoError = "VenmoError"
}
