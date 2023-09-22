//
//  ApplePaymentHeaderResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentHeaderResponse
struct ApplePaymentHeaderResponse: Decodable {
    /// Apple Pay token header public key hash
    let publicKeyHash: String
    /// Apple Pay token header ephemeral public key
    let ephemeralPublicKey: String
    /// Apple Pay token header transaction id
    let transactionId: String
}
