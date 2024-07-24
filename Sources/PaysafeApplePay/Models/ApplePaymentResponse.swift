//
//  ApplePaymentResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentResponse
struct ApplePaymentResponse {
    /// Payment handle token
    let paymentHandleToken: String
    /// Status
    let status: PaymentHandleTokenStatus
    /// PSApplePayFinalizeBlock
    let completion: PSApplePayFinalizeBlock?
}
