//
//  PaymentType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentType
public enum PaymentType: String, Codable {
    /// Card
    case card = "CARD"
    /// Venmo
    case venmo = "VENMO"
    /// Unknown
    case unknown = "UNKNOWN"

    public init(from decoder: Decoder) throws {
        self = try PaymentType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
