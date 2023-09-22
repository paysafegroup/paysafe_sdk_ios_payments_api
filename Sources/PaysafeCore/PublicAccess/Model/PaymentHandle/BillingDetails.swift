//
//  BillingDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct BillingDetails: Encodable {
    /// Country
    let country: String
    /// Zip
    let zip: String
    /// State
    let state: String?
    /// City
    let city: String?
    /// Street
    let street: String?
    /// Street 1
    let street1: String?
    /// Street 2
    let street2: String?
    /// Phone
    let phone: String?
    /// Nickname
    let nickName: String?

    /// - Parameters:
    ///   - country: Country
    ///   - zip: Zip
    ///   - state: State
    ///   - city: City
    ///   - street: Street
    ///   - street1: Street 1
    ///   - street2: Street 2
    ///   - phone: Phone
    ///   - nickName: Nickname
    public init(
        country: String,
        zip: String,
        state: String?,
        city: String?,
        street: String?,
        street1: String?,
        street2: String?,
        phone: String?,
        nickName: String?
    ) {
        self.country = country
        self.zip = zip
        self.state = state
        self.city = city
        self.street = street
        self.street1 = street1
        self.street2 = street2
        self.phone = phone
        self.nickName = nickName
    }

    /// BillingDetailsRequest
    var request: BillingDetailsRequest {
        BillingDetailsRequest(
            country: country,
            zip: zip,
            nickName: nickName,
            street: street,
            street1: street1,
            street2: street2,
            city: city,
            state: state,
            phone: phone
        )
    }
}
