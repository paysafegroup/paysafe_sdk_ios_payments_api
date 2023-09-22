//
//  ApplePaymentMethod.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentMethod
public struct ApplePaymentMethod: Codable {
    /// Display name
    public let displayName: String?
    /// Network
    public let network: String?
    /// Type
    public let type: String
}
