//
//  CardDetails.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

/// CardDetails
struct CardDetails: Decodable {
    /// Last digits
    let lastDigits: String
    /// Card expiry
    let cardExpiry: CardExpiry
    /// Card bin
    let cardBin: String
    /// Card type
    let cardType: CardType
    /// Cardholder name
    let holderName: String
    /// Card status
    let status: String
    /// Card category
    let cardCategory: String
    /// Issuing country
    let issuingCountry: String
}
