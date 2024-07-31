//
//  PSTokenizable.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Protocol that ensures a valid base tokenization for every payment method
/// PSTokenizable is Encodable to log data in a native and efficient way
public protocol PSTokenizable: Encodable {
    /// Payment amount in minor units
    var amount: Int { get }
    /// Currency code
    var currencyCode: String { get }
    /// Transaction type
    var transactionType: TransactionType { get }
    /// Merchant referrence number
    var merchantRefNum: String { get }
    /// Billing details
    var billingDetails: BillingDetails? { get }
    /// User profile
    var profile: Profile? { get }
    /// Account id
    var accountId: String { get }
    /// Merchant descriptor
    var merchantDescriptor: MerchantDescriptor? { get }
    /// Shipping details
    var shippingDetails: ShippingDetails? { get }
    /// Simulator additional data
    var simulator: SimulatorType { get }
}
