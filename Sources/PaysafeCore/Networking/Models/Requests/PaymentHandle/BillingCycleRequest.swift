//
//  BillingCycleRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Billing cycle information for recurring payments.
struct BillingCycleRequest: Encodable {
    /// End date
    let endDate: String?
    /// Frequency
    let frequency: Int?
}
