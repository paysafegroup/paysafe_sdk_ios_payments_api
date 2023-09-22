//
//  AuthenticationCardResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Authentication card details
struct AuthenticationCardResponse: Decodable {
    /// Holder name
    let holderName: String
    /// Last digits
    let lastDigits: String?
    /// Card expiry
    let cardExpiry: AuthenticationCardExpiry
    /// Card bin
    let cardBin: String?
    /// Card type
    let type: AuthenticationCardType?
}

/// Card expiry details
struct AuthenticationCardExpiry: Decodable {
    /// Expiry month
    let month: Int
    /// Expiry year
    let year: Int
}

/// Card supported types
enum AuthenticationCardType: String, Decodable {
    /// Visa card
    case visa = "VI"
    /// Visa Debit card
    case visaDebit = "VD"
    /// Visa Electron card
    case visaElectron = "VE"
    /// Mastercard card
    case mastercard = "MC"
    /// American Express card
    case amex = "AM"
    /// Discover card
    case discover = "DI"
}
