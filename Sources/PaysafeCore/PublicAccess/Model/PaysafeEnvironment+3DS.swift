//
//  PaysafeEnvironment+3DS.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(Paysafe3DS)
import Paysafe3DS
#endif

extension PaysafeEnvironment {
    func to3DSEnvironment() -> Paysafe3DS.APIEnvironment {
        switch self {
        case .production:
            return .production
        case .test:
            return .staging
        }
    }
}
