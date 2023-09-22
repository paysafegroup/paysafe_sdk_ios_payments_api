//
//  PKPaymentMethodType+Extensions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit

extension PKPaymentMethodType {
    func toString() -> String {
        switch self {
        case .unknown:
            return "unknown"
        case .debit:
            return "debit"
        case .credit:
            return "credit"
        case .prepaid:
            return "prepaid"
        case .store:
            return "store"
        case .eMoney:
            return "eMoney"
        @unknown default:
            return "unknown"
        }
    }
}
