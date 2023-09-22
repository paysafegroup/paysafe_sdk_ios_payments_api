//
//  ApplePaymentMethodRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentMethodRequest
struct ApplePaymentMethodRequest: Encodable {
    /// Display name
    let displayName: String?
    /// Network
    let network: String?
    /// Type
    let type: String
}
