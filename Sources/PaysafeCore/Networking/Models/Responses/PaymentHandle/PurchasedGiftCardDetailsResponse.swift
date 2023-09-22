//
//  PurchasedGiftCardDetailsResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PurchasedGiftCardDetailsResponse
struct PurchasedGiftCardDetailsResponse: Decodable {
    /// Amount
    let amount: Int?
    /// Count
    let count: Int?
    /// Currency
    let currency: String?
}
