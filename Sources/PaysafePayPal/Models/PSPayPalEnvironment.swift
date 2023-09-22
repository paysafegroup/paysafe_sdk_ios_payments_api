//
//  PSPayPalEnvironment.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import CorePayments

/// PayPalEnvironment
public enum PSPayPalEnvironment {
    /// PayPal sandbox environment
    case sandbox
    /// PayPal live environment
    case live

    /// CorePayments.Environment
    var toCoreEnvironment: CorePayments.Environment {
        switch self {
        case .sandbox:
            return .sandbox
        case .live:
            return .live
        }
    }
}
