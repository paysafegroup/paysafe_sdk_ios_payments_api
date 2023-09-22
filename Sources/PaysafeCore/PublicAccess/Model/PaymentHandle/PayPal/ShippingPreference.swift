//
//  ShippingPreference.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ShippingPreference
public enum ShippingPreference: Encodable {
    // GET_FROM_FILE
    case getFromFile
    // NO_SHIPPING
    case noShipping
    /// SET_PROVIDED_ADDRESS
    case setProvidedAddress

    /// ShippingPreferenceRequest
    var request: ShippingPreferenceRequest {
        switch self {
        case .getFromFile:
            return .getFromFile
        case .noShipping:
            return .noShipping
        case .setProvidedAddress:
            return .setProvidedAddress
        }
    }
}
