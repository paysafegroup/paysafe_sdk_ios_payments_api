//
//  PurchasedGiftCardDetailsRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PurchasedGiftCardDetailsRequest
struct PurchasedGiftCardDetailsRequest: Encodable {
    /// Amount
    let amount: Int?
    /// Count
    let count: Int?
    /// Currency
    let currency: String?
}
