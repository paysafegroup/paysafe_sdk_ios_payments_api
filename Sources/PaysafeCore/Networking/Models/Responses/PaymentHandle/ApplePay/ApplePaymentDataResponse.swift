//
//  ApplePaymentDataResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentDataResponse
struct ApplePaymentDataResponse: Decodable {
    /// Apple Pay token signature
    let signature: String
    /// Apple Pay token data
    let data: String
    /// Apple Pay token header
    let header: ApplePaymentHeaderResponse
    /// Apple Pay token version
    let version: String
}
