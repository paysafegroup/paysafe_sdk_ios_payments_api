//
//  ApplePaymentResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeApplePay)
import PaysafeApplePay
#endif

/// ApplePaymentResponse
struct ApplePaymentResponse {
    /// Payment handle token
    let paymentHandleToken: String
    /// PSApplePayFinalizeBlock
    let completion: PSApplePayFinalizeBlock?
}
