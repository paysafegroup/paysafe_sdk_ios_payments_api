//
//  PSPayPalEnvironment.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(CorePayments)
import CorePayments
#else
import PayPal
#endif

/// PayPalEnvironment
public enum PSPayPalEnvironment {
    /// PayPal sandbox environment
    case sandbox
    /// PayPal live environment
    case live

    /// CorePayments.Environment
    var toCoreEnvironment: Environment {
        switch self {
        case .sandbox:
            return .sandbox
        case .live:
            return .live
        }
    }
}
