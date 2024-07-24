//
//  AuthenticationCardType+PSCardBrand.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

extension AuthenticationCardType {
    /// Associated PSCardBrand
    public func toPSCardBrand() -> PSCardBrand {
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
