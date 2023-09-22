//
//  PSPayPalTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSPayPalTokenizeOptions
public struct PSPayPalTokenizeOptions: PSTokenizable {
    /// Payment amount in minor units
    public let amount: Int
    /// Currency code
    public let currencyCode: String
    /// Transaction type
    public var transactionType: TransactionType
    /// Merchant reference number
    public let merchantRefNum: String
    /// Billing details
    public var billingDetails: BillingDetails?
    /// User profile
    public var profile: Profile?
    /// Account id
    public let accountId: String
    /// Merchant descriptor
    public var merchantDescriptor: MerchantDescriptor?
    /// Shipping details
    public var shippingDetails: ShippingDetails?
    /// PayPal additional data
    public let paypal: PayPalAdditionalData?

    /// - Parameters:
    ///   - amount: Payment amount in minor units
    ///   - currencyCode: Currency code
    ///   - transactionType: Transaction type
    ///   - merchantRefNum: Merchant referrence number
    ///   - billingDetails: Billing details
    ///   - profile: User profile
    ///   - accountId: Account id
    ///   - merchantDescriptor: Merchant descriptor
    ///   - shippingDetails: Shipping details
    ///   - paypal: Paypal additional data
    public init(
        amount: Int,
        currencyCode: String,
        transactionType: TransactionType,
        merchantRefNum: String,
        billingDetails: BillingDetails? = nil,
        profile: Profile? = nil,
        accountId: String,
        merchantDescriptor: MerchantDescriptor? = nil,
        shippingDetails: ShippingDetails? = nil,
        paypal: PayPalAdditionalData? = nil
    ) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.transactionType = transactionType
        self.merchantRefNum = merchantRefNum
        self.billingDetails = billingDetails
        self.profile = profile
        self.accountId = accountId
        self.merchantDescriptor = merchantDescriptor
        self.shippingDetails = shippingDetails
        self.paypal = paypal
    }
}
