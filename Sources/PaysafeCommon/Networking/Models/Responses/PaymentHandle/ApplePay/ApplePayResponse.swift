//
//  ApplePayResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayResponse
public struct ApplePayResponse: Decodable {
    /// ApplePayPaymentTokenRequest
    public let applePayPaymentToken: ApplePayPaymentTokenResponse
}
