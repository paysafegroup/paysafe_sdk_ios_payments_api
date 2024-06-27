//
//  PaymentMethod.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

/// Available payment methods
enum PaymentMethod {
    /// Credit card payment method
    case creditCard
    /// Apple pay payment method
    case applePay
    /// Venmo payment method
    case venmo

    /// Payment method icon name
    var iconName: String {
        switch self {
        case .creditCard:
            return "paymentMethods.creditCard"
        case .applePay:
            return "paymentMethods.applePay"
        case .venmo:
            return "paymentMethods.venmo"
        }
    }

    /// Payment method icon width
    var iconWidth: CGFloat {
        switch self {
        case .creditCard:
            return 33.0
        case .applePay:
            return 42.0
        case .venmo:
            return 100.0
        }
    }

    /// Payment method title
    var title: String? {
        switch self {
        case .creditCard:
            return "Credit card"
        case .applePay, .venmo:
            return nil
        }
    }

    /// Payment method enabled state
    var isEnabled: Bool {
        switch self {
        case .creditCard, .applePay, .venmo:
            return true
        }
    }
}
