//
//  ShipMethod.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Shipping method
public enum ShipMethod: String, Encodable {
    case nextDay = "N"
    /// Two days service
    case twoDayService = "T"
    /// Lowest cost
    case lowestCost = "C"
    /// Other
    case other = "O"

    /// ShipMethodRequest
    var request: ShipMethodRequest {
        switch self {
        case .nextDay:
            return .nextDay
        case .twoDayService:
            return .twoDayService
        case .lowestCost:
            return .lowestCost
        case .other:
            return .other
        }
    }
}
