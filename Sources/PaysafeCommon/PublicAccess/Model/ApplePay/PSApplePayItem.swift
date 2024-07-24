//
//  PSApplePayItem.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSApplePayItem
public struct PSApplePayItem: Encodable {
    /// Payment item label
    public let label: String
    /// Request billing address
    public let requestBillingAddress: Bool

    /// - Parameters:
    ///   - label: Payment item label
    ///   - requestBillingAddress: Request billing address
    public init(
        label: String,
        requestBillingAddress: Bool
    ) {
        self.label = label
        self.requestBillingAddress = requestBillingAddress
    }
}
