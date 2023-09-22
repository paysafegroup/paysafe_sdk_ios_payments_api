//
//  MessageCategoryRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the category of the message for a specific use case
public enum MessageCategoryRequest: String, Encodable {
    /// Payment
    case payment = "PAYMENT"
    /// Non payment
    case nonPayment = "NON_PAYMENT"
}
