//
//  BillingContact.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Billing contact data gathered from the user if 'PSApplePayTokenizeOptions.requestBillingAddress' is true.
public struct BillingContact: Codable {
    var addressLines: [String]
    var countryCode: String?
    var email: String?
    var locality: String?
    var name: String
    var phone: String?
    var country: String?
    var postalCode: String?
    var administrativeArea: String?
}
