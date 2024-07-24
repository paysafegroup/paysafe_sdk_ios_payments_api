//
//  ShippingIndicator.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the shipping method for the transaction.
public enum ShippingIndicator: String {
    /// Ship to billing address
    case shiptToBillingAddress = "SHIP_TO_BILLING_ADDRESS"
    /// Ship to verified address
    case shipToVerifiedAddress = "SHIP_TO_VERIFIED_ADDRESS"
    /// Ship to different address
    case shipToDifferentAddress = "SHIP_TO_DIFFERENT_ADDRESS"
    /// Ship to store
    case shipToStore = "SHIP_TO_STORE"
    /// Digital goods
    case digitalGoods = "DIGITAL_GOODS"
    /// Travel and event tickets
    case travelAndEventTickets = "TRAVEL_AND_EVENT_TICKETS"
    /// Other
    case other = "OTHER"
}
