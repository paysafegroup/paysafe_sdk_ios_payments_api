//
//  ApplePayRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayRequest
public struct ApplePayRequest: Encodable {
    /// Label
    public let label: String
    /// Request billing address
    public let requestBillingAddress: Bool
    /// ApplePayPaymentTokenRequest
    public let applePayPaymentToken: ApplePayPaymentTokenRequest

    public init(label: String, requestBillingAddress: Bool, applePayPaymentToken: ApplePayPaymentTokenRequest) {
        self.label = label
        self.requestBillingAddress = requestBillingAddress
        self.applePayPaymentToken = applePayPaymentToken
    }
}
