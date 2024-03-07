//
//  PaysafeEnvironment+PayPal.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafePayPal)
import PaysafePayPal
#endif

extension PaysafeEnvironment {
    func toPayPalEnvironment() -> PSPayPalEnvironment {
        switch self {
        case .production:
            return .live
        case .test:
            return .sandbox
        }
    }
}
