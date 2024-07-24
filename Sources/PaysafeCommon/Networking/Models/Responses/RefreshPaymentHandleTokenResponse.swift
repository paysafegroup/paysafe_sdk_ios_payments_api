//
//  RefreshPaymentHandleTokenResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Refresh payment handle status response
public struct RefreshPaymentHandleTokenResponse: Decodable {
    /// Payment handle token status
    let status: PaymentHandleTokenStatus
    /// Payment handle token
    let paymentHandleToken: String
}
