//
//  PurchasedGiftCardDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct PurchasedGiftCardDetails: Encodable {
    /// Amount
    let amount: Int?
    /// Count
    let count: Int?
    /// Currency
    let currency: String?

    /// - Parameters:
    ///   - amount: Amount
    ///   - count: Count
    ///   - currency: Currency
    public init(
        amount: Int?,
        count: Int?,
        currency: String?
    ) {
        self.amount = amount
        self.count = count
        self.currency = currency
    }

    /// PurchasedGiftCardDetailsRequest
    var request: PurchasedGiftCardDetailsRequest {
        PurchasedGiftCardDetailsRequest(
            amount: amount,
            count: count,
            currency: currency
        )
    }
}
