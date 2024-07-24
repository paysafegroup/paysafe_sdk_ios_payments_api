//
//  ShippingDetailsUsageRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ShippingDetailsUsageRequest
struct ShippingDetailsUsageRequest: Encodable {
    /// Cardholder name match
    let cardHolderNameMatch: Bool?
    /// Initial usage date
    let initialUsageDate: String?
    /// Initial usage range
    let initialUsageRange: InitialUsageRangeRequest?
}
