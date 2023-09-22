//
//  BillingCycle.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Billing cycle information for recurring payments.
public struct BillingCycle: Encodable {
    /// End date
    let endDate: String
    /// Frequency
    let frequency: Int

    /// - Parameters:
    ///   - endDate: End date
    ///   - phone: Phone
    public init(
        endDate: String,
        frequency: Int
    ) {
        self.endDate = endDate
        self.frequency = frequency
    }
}
