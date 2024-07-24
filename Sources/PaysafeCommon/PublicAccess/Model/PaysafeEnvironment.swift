//
//  PaysafeEnvironment.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Paysafe environment
public enum PaysafeEnvironment {
    /// Paysafe production environment
    case production
    /// Paysafe test environment
    case test

    /// Base url
    public var baseURL: String {
        switch self {
        case .production:
            return "https://api.paysafe.com"
        case .test:
            return "https://api.test.paysafe.com"
        }
    }
}
