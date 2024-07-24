//
//  BillingContact.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Billing contact data gathered from the user if 'PSApplePayTokenizeOptions.requestBillingAddress' is true.
public struct BillingContact: Codable {
    public var addressLines: [String]
    public var countryCode: String?
    public var email: String?
    public var locality: String?
    public var name: String
    public var phone: String?
    public var country: String?
    public var postalCode: String?
    public var administrativeArea: String?
    
    public init(addressLines: [String], countryCode: String? = nil, email: String? = nil, locality: String? = nil, name: String, phone: String? = nil, country: String? = nil, postalCode: String? = nil, administrativeArea: String? = nil) {
        self.addressLines = addressLines
        self.countryCode = countryCode
        self.email = email
        self.locality = locality
        self.name = name
        self.phone = phone
        self.country = country
        self.postalCode = postalCode
        self.administrativeArea = administrativeArea
    }
}
