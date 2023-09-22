//
//  ApplePayTokenRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayTokenRequest
struct ApplePayTokenRequest: Encodable {
    /// Payment data
    let paymentData: ApplePaymentDataRequest?
    /// Payment method
    let paymentMethod: ApplePaymentMethodRequest
    /// Transaction identifier
    let transactionIdentifier: String
}
