//
//  PaymentRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

typealias ReturnLinkRequest = ReturnLink

/// PaymentRequest
struct PaymentRequest: Encodable {
    /// Merchant reference number
    let merchantRefNum: String
    /// Transaction type
    let transactionType: TransactionTypeRequest
    /// Card
    var card: CardRequest?
    /// Account id
    let accountId: String?
    /// Payment type
    let paymentType: PaymentType
    /// Amount
    let amount: Double
    /// Currency code
    var currencyCode: String
    /// Return links
    var returnLinks: [ReturnLinkRequest]
    /// Profile
    let profile: ProfileRequest?
    /// ThreeDS
    let threeDs: ThreeDSRequest?
    /// Billing details
    let billingDetails: BillingDetailsRequest?
    /// Merchant descriptor
    let merchantDescriptor: MerchantDescriptorRequest?
    /// Shipping details
    let shippingDetails: ShippingDetailsRequest?
    /// Single use customer token
    let singleUseCustomerToken: String?
    /// Payment handle token used for saved cards
    let paymentHandleTokenFrom: String?
    /// Apple Pay request
    let applePay: ApplePayRequest?
    /// PayPal request
    let paypal: PayPalRequest?
}
