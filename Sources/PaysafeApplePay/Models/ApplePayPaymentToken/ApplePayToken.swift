//
//  ApplePayToken.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayToken
public struct ApplePayToken: Decodable {
    /// Payment data
    public let paymentData: ApplePaymentData?
    /// Payment method
    public let paymentMethod: ApplePaymentMethod
    /// Transaction identifier
    public let transactionIdentifier: String
}
