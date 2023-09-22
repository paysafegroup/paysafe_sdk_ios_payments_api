//
//  CardResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// CardResponse
struct CardResponse: Decodable {
    /// Card expiry response
    let cardExpiry: CardExpiryResponse?
    /// Cardholder name
    let holderName: String?
    /// Card type
    let cardType: String?
    /// Card bin
    let cardBin: String?
    /// Last digits
    let lastDigits: String?
    /// Card category
    let cardCategory: String?
    /// Status
    let status: String?
}
