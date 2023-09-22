//
//  ShippingDetailsUsageResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ShippingDetailsUsageResponse
struct ShippingDetailsUsageResponse: Decodable {
    /// Cardholder name match
    let cardHolderNameMatch: Bool?
    /// Initial usage date
    let initialUsageDate: String?
    /// Initial usage range
    let initialUsageRange: InitialUsageRangeResponse
}
