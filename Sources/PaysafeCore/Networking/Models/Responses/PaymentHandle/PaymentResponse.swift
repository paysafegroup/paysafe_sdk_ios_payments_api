//
//  PaymentResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

typealias ReturnLinkResponse = ReturnLink

/// PaymentResponse
struct PaymentResponse: Decodable {
    /// Payment response id
    let id: String?
    /// Merchant reference number
    let merchantRefNum: String
    /// Card
    let card: CardResponse?
    /// Account id
    let accountId: String?
    /// Payment type
    let paymentType: PaymentType?
    /// Return links
    let returnLinks: [ReturnLinkResponse]
    /// Apple Pay response
    let applePay: ApplePayResponse?
    /// Payment handle token
    let paymentHandleToken: String
    /// Status
    let status: String
    /// Links
    let links: [ReturnLinkResponse]?
    /// Gateway response
    let gatewayResponse: GatewayResponse?
}
