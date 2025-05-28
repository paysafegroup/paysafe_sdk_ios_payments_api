//
//  PSVenmoTokenizeOptions.swift
//
//
//  Created by Eduardo Oliveros on 5/28/24.
//

/// PSVenmoTokenizeOptions
public struct PSVenmoTokenizeOptions: PSTokenizable {
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
    /// Dub Check
    public let dupCheck: Bool
    /// Merchant descriptor
    public var merchantDescriptor: MerchantDescriptor?
    /// Shipping details
    public var shippingDetails: ShippingDetails?
    /// Device Finger Printing
    public var deviceFingerprinting: DeviceFingerprinting?
    /// SingleUseCustomerToken
    public var singleUseCustomerToken: String?
    /// Simulator additional data
    public var simulator: SimulatorType
    /// Venmo additional data
    public let venmo: VenmoAdditionalData?
    /// ExpoAlternatePayments parameter
    public var expoAlternatePayments: Bool?

    /// - Parameters:
    ///   - amount: Payment amount in minor units
    ///   - currencyCode: Currency code
    ///   - transactionType: Transaction type
    ///   - merchantRefNum: Merchant referrence number
    ///   - billingDetails: Billing details
    ///   - profile: User profile
    ///   - accountId: Account id
    ///   - dupCheck: DupCheck
    ///   - merchantDescriptor: Merchant descriptor
    ///   - shippingDetails: Shipping details
    ///   - deviceFingerprinting: Device finger printing
    ///   - venmo: Venmo additional data
    ///   - expoAlternatePayments: Optional. When true, returns result of the action not as nil
    public init(
        amount: Int,
        currencyCode: String,
        transactionType: TransactionType,
        merchantRefNum: String,
        billingDetails: BillingDetails? = nil,
        profile: Profile? = nil,
        accountId: String,
        dupCheck: Bool,
        merchantDescriptor: MerchantDescriptor? = nil,
        shippingDetails: ShippingDetails? = nil,
        deviceFingerprinting: DeviceFingerprinting? = nil,
        singleUseCustomerToken: String? = nil,
        simulator: SimulatorType = .externalSimulator,
        venmo: VenmoAdditionalData? = nil,
        expoAlternatePayments: Bool? = nil
    ) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.transactionType = transactionType
        self.merchantRefNum = merchantRefNum
        self.billingDetails = billingDetails
        self.profile = profile
        self.accountId = accountId
        self.dupCheck = dupCheck
        self.singleUseCustomerToken = singleUseCustomerToken
        self.deviceFingerprinting = deviceFingerprinting
        self.merchantDescriptor = merchantDescriptor
        self.shippingDetails = shippingDetails
        self.simulator = simulator
        self.venmo = venmo
        self.expoAlternatePayments = expoAlternatePayments
    }
}
