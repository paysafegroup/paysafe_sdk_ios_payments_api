//
//  PaysafeEnvironment+PayPal.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafePayPal

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
