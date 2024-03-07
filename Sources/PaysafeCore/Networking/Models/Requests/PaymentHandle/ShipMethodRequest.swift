//
//  ShipMethodRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Shipping method
enum ShipMethodRequest: String, Encodable {
    /// Next day
    case nextDay = "N"
    /// Two days service
    case twoDayService = "T"
    /// Lowest cost
    case lowestCost = "C"
    /// Other
    case other = "O"
}
