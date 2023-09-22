//
//  PSCardBrand.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Card brands which a payment card could be
public enum PSCardBrand: CaseIterable {
    /// Visa card
    case visa
    /// Mastercard card
    case mastercard
    /// American Express card
    case amex
    /// Discover card
    case discover
    /// Unknown card
    case unknown
}
