//
//  ApplePaymentDataRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentDataRequest
public struct ApplePaymentDataRequest: Encodable {
    /// Apple Pay token signature
    let signature: String
    /// Apple Pay token data
    let data: String
    /// Apple Pay token header
    let header: ApplePaymentHeaderRequest
    /// Apple Pay token version
    let version: String
    public init(signature: String, data: String, header: ApplePaymentHeaderRequest, version: String) {
        self.signature = signature
        self.data = data
        self.header = header
        self.version = version
    }
}
