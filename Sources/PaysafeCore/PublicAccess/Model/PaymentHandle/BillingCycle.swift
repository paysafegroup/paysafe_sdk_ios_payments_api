//
//  BillingCycle.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Billing cycle information for recurring payments.
public struct BillingCycle: Encodable {
    /// End date
    let endDate: String?
    /// Frequency
    let frequency: Int?

    /// - Parameters:
    ///   - endDate: End date
    ///   - frequency: Phone
    public init(
        endDate: String? = nil,
        frequency: Int? = nil
    ) {
        self.endDate = endDate
        self.frequency = frequency
    }

    /// BillingCycleRequest
    var request: BillingCycleRequest {
        BillingCycleRequest(
            endDate: endDate,
            frequency: frequency
        )
    }
}
