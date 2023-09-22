//
//  ShippingDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct ShippingDetails: Encodable {
    /// Shipping method
    let shipMethod: String?
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

    /// ShippingDetailsRequest
    var request: ShippingDetailsRequest {
        ShippingDetailsRequest(
            shipMethod: shipMethod,
            street: street,
            street2: street2,
            city: city,
            state: state,
            country: country,
            zip: zip
        )
    }
}
