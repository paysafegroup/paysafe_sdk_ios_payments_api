//
//  SavedCardTokens.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Contains the tokens necessary for using a saved card payment method
struct SavedCardTokens {
    /// Single use customer token
    let singleUseCustomerToken: String?
    /// Payment token
    let paymentToken: String?

    /// Both singleUseCustomerToken and paymentToken are required for a valid SavedCardTokens variable
    init?(singleUseCustomerToken: String?, paymentToken: String?) {
        guard let singleUseCustomerToken, let paymentToken else { return nil }
        self.singleUseCustomerToken = singleUseCustomerToken
        self.paymentToken = paymentToken
    }
}
