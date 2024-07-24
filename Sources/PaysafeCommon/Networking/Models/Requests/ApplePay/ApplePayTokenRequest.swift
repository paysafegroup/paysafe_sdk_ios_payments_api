//
//  ApplePayTokenRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayTokenRequest
public struct ApplePayTokenRequest: Encodable {
    /// Payment data
    let paymentData: ApplePaymentDataRequest?
    /// Payment method
    let paymentMethod: ApplePaymentMethodRequest
    /// Transaction identifier
    let transactionIdentifier: String
    public init(paymentData: ApplePaymentDataRequest?, paymentMethod: ApplePaymentMethodRequest, transactionIdentifier: String) {
        self.paymentData = paymentData
        self.paymentMethod = paymentMethod
        self.transactionIdentifier = transactionIdentifier
    }
}
