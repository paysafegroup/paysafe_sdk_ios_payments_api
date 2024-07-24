//
//  ApplePaymentMethodResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentMethodResponse
struct ApplePaymentMethodResponse: Decodable {
    /// Display name
    let displayName: String?
    /// Network
    let network: String?
    /// Type
    let type: String
}
