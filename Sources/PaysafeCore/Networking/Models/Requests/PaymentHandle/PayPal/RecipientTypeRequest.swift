//
//  RecipientTypeRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// RecipientTypeRequest
enum RecipientTypeRequest: String, Encodable {
    // Email
    case email = "EMAIL"
    // Phone
    case phone = "PHONE"
    /// PayPal id
    case payPalId = "PAYPAL_ID"
    /// User id
    case userId = "USER_ID"
}
