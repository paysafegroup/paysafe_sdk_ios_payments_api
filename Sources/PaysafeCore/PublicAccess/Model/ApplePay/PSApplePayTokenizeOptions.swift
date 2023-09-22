//
//  PSApplePayTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeApplePay

/// PSApplePayTokenizeOptions
public struct PSApplePayTokenizeOptions {
    /// Payment amount in minor units
    let amount: Double
    /// Merchant reference number
    let merchantRefNum: String
    /// Customer details
    let customerDetails: CustomerDetails
    /// Account id
    let accountId: String
    /// Currency code
    let currencyCode: String
    /// PSApplePay payment item
    var psApplePay: PSApplePayItem

    /// - Parameters:
    ///   - amount: Payment amount in minor units
    ///   - merchantRefNum: Merchant reference number
    ///   - customerDetails: Customer details
    ///   - accountId: Account id
    ///   - currencyCode: Currency code
    ///   - psApplePay: PSApplePay payment item
    public init(
        amount: Double,
        merchantRefNum: String,
        customerDetails: CustomerDetails,
        accountId: String,
        currencyCode: String,
        psApplePay: PSApplePayItem
    ) {
        self.amount = amount
        self.merchantRefNum = merchantRefNum
        self.customerDetails = customerDetails
        self.accountId = accountId
        self.currencyCode = currencyCode
        self.psApplePay = psApplePay
    }
}
