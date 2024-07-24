//
//  MessageCategory.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the category of the message for a specific use case
public enum MessageCategory: String, Encodable {
    /// Payment
    case payment = "PAYMENT"
    /// Non payment
    case nonPayment = "NON_PAYMENT"

    /// MessageCategoryRequest
    var request: MessageCategoryRequest {
        switch self {
        case .payment:
            return .payment
        case .nonPayment:
            return .nonPayment
        }
    }
}
