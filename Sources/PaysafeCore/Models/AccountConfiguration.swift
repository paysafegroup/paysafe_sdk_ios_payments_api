//
//  AccountConfiguration.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

typealias CardTypeConfig = [String: String]

/// AccountConfiguration
struct AccountConfiguration {
    /// Id
    let id: String
    /// Is Apple Pay
    let isApplePay: Bool
    /// Card type config
    let cardTypeConfig: CardTypeConfig?
    /// Client id
    let clientId: String?
}
