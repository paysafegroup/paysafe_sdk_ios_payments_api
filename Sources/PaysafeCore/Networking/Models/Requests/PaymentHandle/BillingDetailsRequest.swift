//
//  BillingDetailsRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Card billing address - additional details for the billingDetails object can be found in the Payments API documentation.
struct BillingDetailsRequest: Encodable {
    /// Country
    let country: String
    /// Zip
    let zip: String
    /// Nickname
    let nickName: String?
    /// Street
    let street: String?
    /// Street 1
    let street1: String?
    /// Street 2
    let street2: String?
    /// City
    let city: String?
    /// State
    let state: String?
    /// Phone
    let phone: String?
}
