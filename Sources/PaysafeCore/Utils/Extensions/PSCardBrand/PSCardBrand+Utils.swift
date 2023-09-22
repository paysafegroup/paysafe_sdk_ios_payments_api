//
//  PSCardBrand+Utils.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSCardBrand utils
extension PSCardBrand {
    /// Card validation pattern
    var cardValidationPattern: String {
        switch self {
        case .visa:
            return "^4\\d*$"
        case .mastercard:
            return "^(5[1-5]|222[1-8]|2229[0-9]|22[3-9]|2[3-6]|27[01]|2720[0-8]|27209)\\d*$"
        case .amex:
            return "^3[47]\\d*$"
        case .discover:
            return "^6(011(0[0-3]|0[5-9]|2|3|4|7[47]|8[6-9]|9)|4[4-9]|5[0-9])\\d*$"
        case .unknown:
            return ""
        }
    }

    /// Card number format
    var cardNumberFormat: [Int] {
        switch self {
        case .amex:
            return [4, 6, 5]
        default:
            return [4, 4, 4, 4]
        }
    }

    /// Card number length, computed from cardNumberFormat
    var cardNumberLength: Int {
        cardNumberFormat.reduce(0, +)
    }

    /// Card brand icon name
    var iconName: String? {
        switch self {
        case .visa:
            return "card_visa"
        case .mastercard:
            return "card_mastercard"
        case .amex:
            return "card_amex"
        case .discover:
            return "card_discover"
        case .unknown:
            return nil
        }
    }

    /// Valid state, true for any value besides `unknown`
    var isValid: Bool {
        self != .unknown
    }

    /// CVV length
    var cvvLength: Int {
        switch self {
        case .amex, .unknown:
            return 4
        default:
            return 3
        }
    }
}
