//
//  PaymentResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public typealias ReturnLinkResponse = ReturnLink

/// PaymentResponse
public struct PaymentResponse: Decodable {
    /// Payment response id
    public let id: String?
    /// Merchant reference number
    public let merchantRefNum: String
    /// Card
    public let card: CardResponse?
    /// Account id
    public let accountId: String?
    /// Payment type
    public let paymentType: PaymentType?
    /// Return links
    public let returnLinks: [ReturnLinkResponse]
    /// Apple Pay response
    public let applePay: ApplePayResponse?
    /// Payment handle token
    public let paymentHandleToken: String
    /// Status
    public let status: String
    /// Links
    public let links: [ReturnLinkResponse]?
    /// Gateway response
    public let gatewayResponse: GatewayResponse?
    /// Action
    public let action: String?
}
