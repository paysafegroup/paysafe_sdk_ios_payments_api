//
//  PaymentType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentType
enum PaymentType: String, Codable {
    /// Card
    case card = "CARD"
    /// PayPal
    case payPal = "PAYPAL"
    /// Unknown
    case unknown = "UNKNOWN"

    init(from decoder: Decoder) throws {
        self = try PaymentType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
