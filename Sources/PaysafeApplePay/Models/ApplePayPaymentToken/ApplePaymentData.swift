//
//  ApplePaymentData.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentData
public struct ApplePaymentData: Decodable {
    /// Apple Pay token signature
    public let signature: String
    /// Apple Pay token data
    public let data: String
    /// Apple Pay token header
    public let header: ApplePaymentHeader
    /// Apple Pay token version
    public let version: String
}
