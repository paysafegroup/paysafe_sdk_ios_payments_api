//
//  BillingDetailsResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Use this for response only because it has the additional fields:
/// id, status
struct BillingDetailsResponse: Decodable {
    /// Id
    let id: String?
    /// Status
    let status: String?
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
