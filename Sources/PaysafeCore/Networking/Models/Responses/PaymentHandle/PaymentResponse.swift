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
    let id: String
    /// Merchant reference number
    let merchantRefNum: String
    /// Transaction type
    let transactionType: TransactionTypeResponse
    /// Card
    let card: CardResponse?
    /// Account id
    let accountId: String?
    /// Payment type
    let paymentType: PaymentType?
    /// Amount
    let amount: Double
    /// Currency code
    let currencyCode: String
    /// Return links
    let returnLinks: [ReturnLinkResponse]
    /// ThreeDS
    let threeDs: ThreeDSResponse?
    /// Billing details
    let billingDetails: BillingDetailsResponse?
    /// Merchant descriptor
    let merchantDescriptor: MerchantDescriptorResponse?
    /// Apple Pay response
    let applePay: ApplePayResponse?
    /// Payment handle token
    let paymentHandleToken: String
    /// Transaction time
    let txnTime: String
    /// Status
    let status: String
    /// Links
    let links: [ReturnLinkResponse]?
    /// Action
    let action: String?
    /// Usage
    let usage: String
    /// Time to live seconds
    let timeToLiveSeconds: Int
    /// Execution mode
    let executionMode: String?
    /// Gateway response
    let gatewayResponse: GatewayResponse?
}
