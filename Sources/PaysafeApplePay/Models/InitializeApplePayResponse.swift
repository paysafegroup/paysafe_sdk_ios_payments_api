//
//  InitializeApplePayResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// InitializeApplePayResponse
public struct InitializeApplePayResponse {
    /// Apple Pay payment token
    public let applePayPaymentToken: ApplePayPaymentToken
    /// PSApplePayFinalizeBlock
    public let completion: PSApplePayFinalizeBlock?
}
