//
//  ShippingDetailsRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ShippingDetailsRequest
struct ShippingDetailsRequest: Encodable {
    /// Shipping method
    let shipMethod: ShipMethodRequest?
    /// Street
    let street: String?
    /// Street 2
    let street2: String?
    /// City
    let city: String?
    /// State
    let state: String?
    /// Country
    let country: String?
    /// Zip
    let zip: String?
}
