//
//  PaymentHandle.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentHandle
struct PaymentHandle {
    /// Account id
    let accountId: String?
    /// Merchant reference number
    let merchantRefNum: String
    /// Payment handle token
    let paymentHandleToken: String
    /// Redirect payment link
    let redirectPaymentLink: ReturnLink?
    /// Return links
    let returnLinks: [ReturnLink]
    /// Order id
    let orderId: String?
}
