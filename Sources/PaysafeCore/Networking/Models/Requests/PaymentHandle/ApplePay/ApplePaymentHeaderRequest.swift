//
//  ApplePaymentHeaderRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentHeaderRequest
struct ApplePaymentHeaderRequest: Encodable {
    /// Apple Pay token header public key hash
    let publicKeyHash: String
    /// Apple Pay token header ephemeral public key
    let ephemeralPublicKey: String
    /// Apple Pay token header transaction id
    let transactionId: String
}
