//
//  AccountConfigurationResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// AccountConfigurationResponse
struct AccountConfigurationResponse: Decodable {
    /// Id
    let id: String
    /// Is Apple Pay
    let isApplePay: Bool
    /// Card type config
    let cardTypeConfig: CardTypeConfig?
}
