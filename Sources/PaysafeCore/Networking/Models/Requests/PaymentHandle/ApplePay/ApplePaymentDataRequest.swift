//
//  ApplePaymentDataRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentDataRequest
struct ApplePaymentDataRequest: Encodable {
    /// Apple Pay token signature
    let signature: String
    /// Apple Pay token data
    let data: String
    /// Apple Pay token header
    let header: ApplePaymentHeaderRequest
    /// Apple Pay token version
    let version: String
}
