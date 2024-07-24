//
//  ApplePaymentHeaderRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentHeaderRequest
public struct ApplePaymentHeaderRequest: Encodable {
    /// Apple Pay token header public key hash
    let publicKeyHash: String
    /// Apple Pay token header ephemeral public key
    let ephemeralPublicKey: String
    /// Apple Pay token header transaction id
    let transactionId: String
    public init(publicKeyHash: String, ephemeralPublicKey: String, transactionId: String) {
        self.publicKeyHash = publicKeyHash
        self.ephemeralPublicKey = ephemeralPublicKey
        self.transactionId = transactionId
    }
}
