//
//  CardType.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

/// CardType
enum CardType: String, Decodable {
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
