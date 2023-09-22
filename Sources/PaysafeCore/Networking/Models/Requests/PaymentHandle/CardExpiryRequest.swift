//
//  CardExpiryRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// CardExpiryRequest
struct CardExpiryRequest: Encodable {
    /// Expiry month
    let month: Int
    /// Expiry year
    let year: Int

    /// - Parameters:
    ///   - month: Expiry month
    ///   - year: Expiry year
    init?(
        month: Int?,
        year: Int?
    ) {
        guard let month, let year else { return nil }
        self.month = month
        self.year = year
    }
}
