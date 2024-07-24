//
//  ApplePayPaymentTokenRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayPaymentTokenRequest
public struct ApplePayPaymentTokenRequest: Encodable {
    /// ApplePayTokenRequest
    let token: ApplePayTokenRequest
    /// Billing contact
    let billingContact: BillingContact?
    public init(token: ApplePayTokenRequest, billingContact: BillingContact?) {
        self.token = token
        self.billingContact = billingContact
    }
}

