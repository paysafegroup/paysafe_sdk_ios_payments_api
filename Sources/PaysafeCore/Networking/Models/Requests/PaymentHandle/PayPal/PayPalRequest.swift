//
//  PayPalRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PayPalRequest
struct PayPalRequest: Encodable {
    /// Consumer id
    let consumerId: String
    /// Recipient description
    let recipientDescription: String?
    /// Language
    let language: LanguageRequest?
    /// Shipping preference
    let shippingPreference: ShippingPreferenceRequest?
    /// Consumer message
    let consumerMessage: String?
    /// Order description
    let orderDescription: String?
    /// Recipient type
    let recipientType: RecipientTypeRequest?
}
