//
//  ApplePaymentResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeApplePay

/// ApplePaymentResponse
struct ApplePaymentResponse {
    /// Payment handle token
    let paymentHandleToken: String
    /// PSApplePayFinalizeBlock
    let completion: PSApplePayFinalizeBlock?
}
