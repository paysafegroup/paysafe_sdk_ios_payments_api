//
//  ApplePayAdditionalData.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// The two-uppercase-character ISO 3166 country code.
/// https://developer.paysafe.com/en/support/reference-information/codes/#c319
public struct ApplePayAdditionalData: Encodable {
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
