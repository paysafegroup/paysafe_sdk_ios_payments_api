//
//  PSPayPalTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSPayPalTokenizeOptions
public struct PSPayPalTokenizeOptions {
    /// Payment amount in minor units
    let amount: Double
    /// Merchant reference number
    let merchantRefNum: String
    /// Customer details
    let customerDetails: CustomerDetails
    /// Account id
    let accountId: String?
    /// Currency code
    let currencyCode: String
    /// Consumer id
    let consumerId: String
    /// Recipient description
    let recipientDescription: String?
    /// Language
    let language: Language?
    /// Shipping preference
    let shippingPreference: ShippingPreference?
    /// Consumer message
    let consumerMessage: String?
    /// Order description
    let orderDescription: String?

    /// - Parameters:
    ///   - amount: Payment amount in minor units
    ///   - merchantRefNum: Merchant reference number
    ///   - customerDetails: Customer details
    ///   - accountId: Account id
    ///   - currencyCode: Currency code
    ///   - consumerId: Consumer id
    ///   - recipientDescription: Recipient description
    ///   - language: Language
    ///   - shippingPreference: shippingPreference
    ///   - consumerMessage: Consumer message
    ///   - orderDescription: Order description
    public init(
        amount: Double,
        merchantRefNum: String,
        customerDetails: CustomerDetails,
        accountId: String?,
        currencyCode: String,
        consumerId: String,
        recipientDescription: String? = nil,
        language: Language? = nil,
        shippingPreference: ShippingPreference? = nil,
        consumerMessage: String? = nil,
        orderDescription: String? = nil
    ) {
        self.amount = amount
        self.merchantRefNum = merchantRefNum
        self.customerDetails = customerDetails
        self.accountId = accountId
        self.currencyCode = currencyCode
        self.consumerId = consumerId
        self.recipientDescription = recipientDescription
        self.language = language
        self.shippingPreference = shippingPreference
        self.consumerMessage = consumerMessage
        self.orderDescription = orderDescription
    }
}
