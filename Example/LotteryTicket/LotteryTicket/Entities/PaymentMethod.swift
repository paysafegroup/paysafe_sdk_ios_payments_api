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
    /// PayPal payment method
    case payPal

    /// Payment method icon name
    var iconName: String {
        switch self {
        case .creditCard:
            return "paymentMethods.creditCard"
        case .applePay:
            return "paymentMethods.applePay"
        case .payPal:
            return "paymentMethods.payPal"
        }
    }

    /// Payment method icon width
    var iconWidth: CGFloat {
        switch self {
        case .creditCard:
            return 33.0
        case .applePay:
            return 42.0
        case .payPal:
            return 80.0
        }
    }

    /// Payment method title
    var title: String? {
        switch self {
        case .creditCard:
            return "Credit card"
        case .payPal, .applePay:
            return nil
        }
    }

    /// Payment method enabled state
    var isEnabled: Bool {
        switch self {
        case .creditCard, .applePay, .payPal:
            return true
        }
    }
}
