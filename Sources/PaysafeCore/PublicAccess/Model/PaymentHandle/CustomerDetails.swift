//
//  CustomerDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Customer details
public struct CustomerDetails: Encodable {
    /// Billing details
    let billingDetails: BillingDetails?
    /// Profile
    let profile: Profile?

    /// - Parameters:
    ///   - billingDetails: Billing details
    ///   - profile: Profile
    public init(
        billingDetails: BillingDetails?,
        profile: Profile?
    ) {
        self.billingDetails = billingDetails
        self.profile = profile
    }
}
