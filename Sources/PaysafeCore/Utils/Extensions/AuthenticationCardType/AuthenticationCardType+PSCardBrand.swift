//
//  AuthenticationCardType+PSCardBrand.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

extension AuthenticationCardType {
    /// Associated PSCardBrand
    func toPSCardBrand() -> PSCardBrand {
        switch self {
        case .visa, .visaDebit, .visaElectron:
            return .visa
        case .mastercard:
            return .mastercard
        case .amex:
            return .amex
        case .discover:
            return .discover
        }
    }
}
