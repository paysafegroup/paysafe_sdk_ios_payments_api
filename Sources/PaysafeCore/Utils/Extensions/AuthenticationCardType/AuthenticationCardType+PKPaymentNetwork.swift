//
//  AuthenticationCardType+PKPaymentNetwork.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit

extension AuthenticationCardType {
    /// Associated PKPaymentNetwork
    func toPKPaymentNetwork() -> PKPaymentNetwork {
        switch self {
        case .visa, .visaDebit, .visaElectron:
            return .visa
        case .mastercard:
            return .masterCard
        case .amex:
            return .amex
        case .discover:
            return .discover
        }
    }
}
