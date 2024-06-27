//
//  PSVenmoResult.swift
//
//
//  Created by Eduardo Oliveros on 5/28/24.
//

/// PSVenmoResult
///
public enum PSVenmoBraintreeResult {
    /// Venmo success result
    case success(venmoAccount: VenmoAccount)
    /// Venmo failed result
    case failed
}

public enum PSVenmoResult {
    /// Venmo success result
    case success
    /// Venmo failed result
    case failed
    /// Venmo cancelled result
    case cancelled
}

public struct VenmoAccount: Codable {
    /// The email associated with the Venmo account
    public var email: String?

    /// The external ID associated with the Venmo account
    public var externalID: String?

    /// The first name associated with the Venmo account
    public var firstName: String?

    /// The last name associated with the Venmo account
    public var lastName: String?

    /// The phone number associated with the Venmo account
    public var phoneNumber: String?

    /// The username associated with the Venmo account
    public var username: String?
    
    /// The primary billing address associated with the Venmo account
    public var billingAddress: PostalAddress?
    
    /// The primary shipping address associated with the Venmo account
    public var shippingAddress: PostalAddress?
    
    /// The payment method nonce.
    public var nonce: String

    /// The string identifying the type of the payment method.
    public var type: String

    /// The boolean indicating whether this is a default payment method.
    public var isDefault: Bool
    
    public func serialize() -> String {
        let name = "{\"firstName\":\"" + (firstName ?? "") + "\", \"lastName\":\"" + (lastName ?? "") + "\""
        let venmoAccount = name + ", \"phoneNumber\":\""  + (phoneNumber ?? "") + "\", \"email\": \"" +  (email ?? "") + "\", \"externalId\":\"" + (externalID ?? "") + "\", \"userName\":\"@" + (username ?? "") + "\"}"
        return venmoAccount
    }
}

public struct PostalAddress: Codable {
    /// Optional. Recipient name for shipping address.
    public var recipientName: String?

    /// Line 1 of the Address (eg. number, street, etc).
    public var streetAddress: String?

    /// Optional line 2 of the Address (eg. suite, apt #, etc.).
    public var extendedAddress: String?

    /// City name
    public var locality: String?

    /// 2 letter country code.
    public var countryCodeAlpha2: String?

    /// Zip code or equivalent is usually required for countries that have them.
    public var postalCode: String?

    /// Either a two-letter state code (for the US), or an ISO-3166-2 country subdivision code of up to three letters.
    public var region: String?
}
