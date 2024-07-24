//
//  PaysafeEnvironment+3DS.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

extension PaysafeEnvironment {
    public func to3DSEnvironment() -> Paysafe3DS.APIEnvironment {
        switch self {
        case .production:
            return .production
        case .test:
            return .staging
        }
    }
}
