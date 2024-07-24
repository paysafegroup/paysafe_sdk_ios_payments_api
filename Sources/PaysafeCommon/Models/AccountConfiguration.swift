//
//  AccountConfiguration.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//
public typealias CardTypeConfig = [String: String]

/// AccountConfiguration
public struct AccountConfiguration {
    /// Id
    public let id: String
    /// Is Apple Pay
    public let isApplePay: Bool
    /// Card type config
    public let cardTypeConfig: CardTypeConfig?
    /// Client id
    public let clientId: String?
}
