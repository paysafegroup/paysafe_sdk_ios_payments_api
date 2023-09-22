//
//  ApplePayRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayRequest
struct ApplePayRequest: Encodable {
    /// Label
    let label: String
    /// Request billing address
    let requestBillingAddress: Bool
    /// ApplePayPaymentTokenRequest
    let applePayPaymentToken: ApplePayPaymentTokenRequest
}
