//
//  ApplePaymentHeader.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentHeader
public struct ApplePaymentHeader: Decodable {
    /// Apple Pay token header public key hash
    public let publicKeyHash: String
    /// Apple Pay token header ephemeral public key
    public let ephemeralPublicKey: String
    /// Apple Pay token header transaction id
    public let transactionId: String
}
