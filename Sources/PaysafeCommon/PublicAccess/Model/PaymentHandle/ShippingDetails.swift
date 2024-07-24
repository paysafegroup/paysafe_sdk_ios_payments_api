//
//  ShippingDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct ShippingDetails: Encodable {
    /// Shipping method
    let shipMethod: ShipMethod?
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

    public init(
        shipMethod: ShipMethod?,
        street: String?,
        street2: String?,
        city: String?,
        state: String?,
        country: String?,
        zip: String?
    ) {
        self.shipMethod = shipMethod
        self.street = street
        self.street2 = street2
        self.city = city
        self.state = state
        self.country = country
        self.zip = zip
    }

    /// ShippingDetailsRequest
    var request: ShippingDetailsRequest {
        ShippingDetailsRequest(
            shipMethod: shipMethod?.request,
            street: street,
            street2: street2,
            city: city,
            state: state,
            country: country,
            zip: zip
        )
    }
}
