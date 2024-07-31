//
//  PSApplePayTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSApplePayTokenizeOptions
public struct PSApplePayTokenizeOptions: PSTokenizable {
    /// Internal data updated by apple pay context based on apple pay response
    public var applePay: ApplePayAdditionalData?
    /// Payment amount in minor units
    public var amount: Int
    /// Currency code
    public var currencyCode: String
    /// Transaction type
    public var transactionType: TransactionType
    /// Merchant referrence number
    public var merchantRefNum: String
    /// Billing details
    public var billingDetails: BillingDetails?
    /// User profile
    public var profile: Profile?
    /// Account id
    public var accountId: String
    /// Merchant descriptor
    public var merchantDescriptor: MerchantDescriptor?
    /// Shipping details
    public var shippingDetails: ShippingDetails?
    /// PSApplePay payment item
    public var psApplePay: PSApplePayItem
    /// Requires billing address from apple pay
    public var requestBillingAddress: Bool
    /// Simulator additional data
    public var simulator: SimulatorType

    /// - Parameters:
    ///   - amount: Payment amount in minor units
    ///   - currencyCode: Currency code
    ///   - transactionType: Transaction type
    ///   - merchantRefNum: Merchant reference number
    ///   - billingDetails: Billing details
    ///   - profile: User profile
    ///   - accountId: Account id
    ///   - merchantDescriptor: Merchant descriptor
    ///   - shippingDetails: Shipping details
    ///   - psApplePay: Apple pay item
    ///   - requestBillingAddress: Request billing address from apple pay
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
        simulator: SimulatorType = .externalSimulator,
        psApplePay: PSApplePayItem,
        requestBillingAddress: Bool = false
    ) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.transactionType = transactionType
        self.merchantRefNum = merchantRefNum
        self.psApplePay = psApplePay
        self.billingDetails = billingDetails
        self.profile = profile
        self.accountId = accountId
        self.merchantDescriptor = merchantDescriptor
        self.shippingDetails = shippingDetails
        self.requestBillingAddress = requestBillingAddress
        self.simulator = simulator
    }
}
