//
//  ShippingDetailsUsage.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ShippingDetailsUsage
public struct ShippingDetailsUsage: Encodable {
    /// Card holder name match
    let cardHolderNameMatch: Bool?
    /// Initial usage date
    let initialUsageDate: String?
    /// Initial usage range
    let initialUsageRange: InitialUsageRange

    /// - Parameters:
    ///   - cardHolderNameMatch: Card holder name match
    ///   - initialUsageDate: Initial usage date
    ///   - initialUsageRange: Initial usage range
    public init(
        cardHolderNameMatch: Bool,
        initialUsageDate: String,
        initialUsageRange: InitialUsageRange
    ) {
        self.cardHolderNameMatch = cardHolderNameMatch
        self.initialUsageDate = initialUsageDate
        self.initialUsageRange = initialUsageRange
    }

    /// ShippingDetailsUsageRequest
    var request: ShippingDetailsUsageRequest {
        ShippingDetailsUsageRequest(
            cardHolderNameMatch: cardHolderNameMatch,
            initialUsageDate: initialUsageDate,
            initialUsageRange: initialUsageRange.request
        )
    }
}
