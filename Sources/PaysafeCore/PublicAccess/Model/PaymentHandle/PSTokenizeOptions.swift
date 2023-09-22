//
//  PSTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Optional tokenization settings, that contain information about the 3D Secure (3DS) flow and additional customer data sent to Customer Vault.
public struct PSTokenizeOptions: Encodable {
    /// Payment amount in minor units
    let amount: Double
    /// Currency code
    let currencyCode: String
    /// Transaction type
    let transactionType: TransactionType
    /// Merchant reference number
    let merchantRefNum: String
    /// Customer details
    let customerDetails: CustomerDetails
    /// Account id
    let accountId: String?
    /// Merchant descriptor
    let merchantDescriptor: MerchantDescriptor?
    /// Shipping details
    let shippingDetails: ShippingDetails?
    /// ThreeDS
    let threeDS: ThreeDS?
    /// Apple Pay additional data
    let applePay: ApplePayAdditionalData?
    /// PayPal additional data
    let paypal: PayPalAdditionalData?
    /// Single use customer token
    let singleUseCustomerToken: String?
    /// Payment token from
    let paymentTokenFrom: String?
    /// Render type used for 3ds
    var renderType: RenderType?

    /// - Parameters:
    ///   - amount: Payment amount in minor units
    ///   - currencyCode: Currency code
    ///   - transactionType: Transaction type
    ///   - merchantRefNum: Merchant reference number
    ///   - customerDetails: Customer details
    ///   - merchantDescriptor: Merchant descriptor
    ///   - shippingDetails: Shipping details
    ///   - accountId: Account id
    ///   - threeDS: ThreeDS
    ///   - applePay: Apple Pay additional data
    ///   - paypal: PayPal additional data
    ///   - singleUseCustomerToken: Single use customer token
    ///   - paymentTokenFrom: Payment token from
    public init(
        amount: Double,
        currencyCode: String,
        transactionType: TransactionType,
        merchantRefNum: String,
        customerDetails: CustomerDetails,
        accountId: String?,
        merchantDescriptor: MerchantDescriptor? = nil,
        shippingDetails: ShippingDetails? = nil,
        threeDS: ThreeDS? = nil,
        applePay: ApplePayAdditionalData? = nil,
        paypal: PayPalAdditionalData? = nil,
        singleUseCustomerToken: String? = nil,
        paymentTokenFrom: String? = nil,
        renderType: RenderType? = nil
    ) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.transactionType = transactionType
        self.merchantRefNum = merchantRefNum
        self.customerDetails = customerDetails
        self.accountId = accountId
        self.merchantDescriptor = merchantDescriptor
        self.shippingDetails = shippingDetails
        self.threeDS = threeDS
        self.applePay = applePay
        self.paypal = paypal
        self.singleUseCustomerToken = singleUseCustomerToken
        self.paymentTokenFrom = paymentTokenFrom
        self.renderType = renderType
    }
}
