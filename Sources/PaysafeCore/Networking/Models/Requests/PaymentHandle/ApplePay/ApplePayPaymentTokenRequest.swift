//
//  ApplePayPaymentTokenRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeApplePay)
import PaysafeApplePay
#endif

/// ApplePayPaymentTokenRequest
struct ApplePayPaymentTokenRequest: Encodable {
    /// ApplePayTokenRequest
    let token: ApplePayTokenRequest
    /// Billing contact
    let billingContact: BillingContact?
}
