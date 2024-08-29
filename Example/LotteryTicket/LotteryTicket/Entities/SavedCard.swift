//
//  SavedCard.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments

struct SavedCard: Hashable {
    /// PSCardBrand
    let cardBrand: PSCardBrand
    /// Last digits
    let lastDigits: String
    /// Cardholder name
    let holderName: String
    /// Expiry month
    let expiryMonth: Int
    /// Expiry year
    let expiryYear: Int
    /// Single use customer token
    let singleUseCustomerToken: String
    /// Payment token from
    let paymentTokenFrom: String

    /// Brand icon name
    var brandIconName: String? {
        switch cardBrand {
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

    /// Expiry date string
    var expiryDateString: String {
        "\(String(format: "%02d", expiryMonth))-\(expiryYear)"
    }

    /// Accessibility identifier
    var accessibilityIdentifier: String {
        switch cardBrand {
        case .visa:
            return "VisaCard"
        case .mastercard:
            return "MastercardCard"
        case .amex:
            return "AmexCard"
        case .discover:
            return "DiscoverCard"
        case .unknown:
            return "UnknownCard"
        }
    }
}
