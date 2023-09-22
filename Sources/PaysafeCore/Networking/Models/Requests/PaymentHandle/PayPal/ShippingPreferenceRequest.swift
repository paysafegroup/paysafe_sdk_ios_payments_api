//
//  ShippingPreferenceRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ShippingPreferenceRequest
enum ShippingPreferenceRequest: String, Encodable {
    // GET_FROM_FILE
    case getFromFile = "GET_FROM_FILE"
    // NO_SHIPPING
    case noShipping = "NO_SHIPPING"
    /// SET_PROVIDED_ADDRESS
    case setProvidedAddress = "SET_PROVIDED_ADDRESS"
}
