//
//  ApplePayTokenResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePayTokenResponse
struct ApplePayTokenResponse: Decodable {
    /// Payment data
    let paymentData: ApplePaymentDataResponse?
    /// Payment method
    let paymentMethod: ApplePaymentMethodResponse
    /// Transaction identifier
    let transactionIdentifier: String
}
