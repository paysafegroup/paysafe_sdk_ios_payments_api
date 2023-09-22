//
//  CheckoutFieldType.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

/// Checkout fields
enum CheckoutFieldType {
    /// Payment method checkout field type
    case paymentMethod
    /// Billing address checkout field type
    case billingAddress(address: BillingAddress?)
    /// Promo code checkout field type
    case promoCode
    /// Total checkout field type
    case total(price: Double)

    /// Checkout field title
    var title: String {
        switch self {
        case .paymentMethod:
            return "Payment method"
        case .billingAddress:
            return "Billing address"
        case .promoCode:
            return "Promo code"
        case .total:
            return "Total"
        }
    }

    /// Checkout field detail text
    var detail: String {
        switch self {
        case .paymentMethod:
            return "Select payment method"
        case let .billingAddress(address):
            guard let address else { return "Select billing address" }
            return address.billingAddressString
        case .promoCode:
            return "Pick discount"
        case let .total(price):
            return String(format: "$%.2f", price)
        }
    }

    /// Checkout field tint color
    var tintColor: Color {
        switch self {
        case .paymentMethod:
            return .ltPurple
        case let .billingAddress(address):
            return address != nil ? .ltDarkPurple : .ltPurple
        case .promoCode:
            return .ltPurple
        case .total:
            return .ltDarkPurple
        }
    }
}
