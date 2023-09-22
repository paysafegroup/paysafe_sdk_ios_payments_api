//
//  PaymentHandle.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentHandle
struct PaymentHandle: Decodable {
    /// Id
    let id: String
    /// Status
    let status: String
    /// Usage
    let usage: String
    /// Payment type
    let paymentType: String
    /// Payment handle token
    let paymentHandleToken: String
    /// Card details
    let card: CardDetails
    /// Billing details id
    let billingDetailsId: String
    /// Multi use payment handle id
    let multiUsePaymentHandleId: String
}
