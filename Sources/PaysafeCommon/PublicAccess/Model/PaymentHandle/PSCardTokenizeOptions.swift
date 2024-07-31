//
//  PSCardTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Card payment tokenize options
public struct PSCardTokenizeOptions: PSTokenizable {
    /// Payment amount in minor units
    public let amount: Int
    /// Currency code
    public let currencyCode: String
    /// Transaction type
    public let transactionType: TransactionType
    /// Merchant referrence number
    public let merchantRefNum: String
    /// Billing details
    public let billingDetails: BillingDetails?
    /// User profile
    public let profile: Profile?
    /// Account id
    public let accountId: String
    /// Merchant descriptor
    public let merchantDescriptor: MerchantDescriptor?
    /// Shipping details
    public let shippingDetails: ShippingDetails?
    /// ThreeDS
    public let threeDS: ThreeDS?
    /// SingleUseCustomerToken
    public let singleUseCustomerToken: String?
    /// PaymentTokenFrom
    public let paymentTokenFrom: String?
    /// Render type
    public let renderType: RenderType?
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
    ///   - threeDS: ThreeDS
    ///   - singleUseCustomerToken: Single use customer token
    ///   - paymentTokenFrom: Payment token from
    ///   - renderType: Render type
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
        threeDS: ThreeDS? = nil,
        singleUseCustomerToken: String? = nil,
        paymentTokenFrom: String? = nil,
        simulator: SimulatorType = .externalSimulator,
        renderType: RenderType? = nil
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
        self.threeDS = threeDS
        self.singleUseCustomerToken = singleUseCustomerToken
        self.paymentTokenFrom = paymentTokenFrom
        self.simulator = simulator
        self.renderType = renderType
    }
}
