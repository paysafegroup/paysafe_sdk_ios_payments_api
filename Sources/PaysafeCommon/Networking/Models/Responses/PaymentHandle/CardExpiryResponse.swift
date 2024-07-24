//
//  CardExpiryResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// The difference between the CardExpiry and CardExpiryResponse is the type of the values: String vs Int
struct CardExpiryResponse: Decodable {
    /// Expiry month
    let month: String
    /// Expiry year
    let year: String
}
