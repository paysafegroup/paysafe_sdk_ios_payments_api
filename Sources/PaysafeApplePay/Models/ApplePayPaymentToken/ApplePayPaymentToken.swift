//
//  ApplePayPaymentToken.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayPaymentToken
public struct ApplePayPaymentToken: Decodable {
    /// ApplePayToken
    public let token: ApplePayToken
    /// Billing contact
    public let billingContact: BillingContact?
}
