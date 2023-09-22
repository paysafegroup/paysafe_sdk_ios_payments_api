//
//  PreOrderPurchaseIndicator.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This indicates whether the cardholder is placing an order for available merchandise or merchandise with a future availability or release date.
public enum PreOrderPurchaseIndicator: String {
    /// Merchandise available
    case merchandiseAvailable = "MERCHANDISE_AVAILABLE"
    /// Future availability
    case futureAvailability = "FUTURE_AVAILABILITY"
}
