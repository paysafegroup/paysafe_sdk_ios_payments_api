//
//  ApplePayAdditionalData.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Apple pay additional data
struct ApplePayAdditionalData: Encodable {
    /// Label
    let label: String
    /// Request billing address
    let requestBillingAddress: Bool
    /// ApplePayPaymentTokenRequest
    let applePayPaymentToken: ApplePayPaymentTokenRequest

    /// ApplePayRequest
    var request: ApplePayRequest {
        ApplePayRequest(
            label: label,
            requestBillingAddress: requestBillingAddress,
            applePayPaymentToken: applePayPaymentToken
        )
    }
}
