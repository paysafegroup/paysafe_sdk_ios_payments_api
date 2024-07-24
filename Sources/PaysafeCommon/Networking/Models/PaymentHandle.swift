//
//  PaymentHandle.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentHandle
public struct PaymentHandle {
    /// Payment response id
    public let id: String?
    /// Account id
    public let accountId: String?
    /// Card
    public let card: CardResponse?
    /// Status
    public let status: PaymentHandleTokenStatus
    /// Merchant reference number
    public let merchantRefNum: String
    /// Payment handle token
    public let paymentHandleToken: String
    /// Redirect payment link
    let redirectPaymentLink: ReturnLink?
    /// Return links
    let returnLinks: [ReturnLink]
    /// Order id
    let orderId: String?
    /// Gateway response
    public let gatewayResponse: GatewayResponse?
    /// Action
    public let action: String?
}
