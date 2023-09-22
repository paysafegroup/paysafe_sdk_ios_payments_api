//
//  RecipientType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// RecipientType
public enum RecipientType: Encodable {
    // Email
    case email
    // Phone
    case phone
    /// PayPal id
    case payPalId
    /// User id
    case userId

    /// RecipientTypeRequest
    var request: RecipientTypeRequest {
        switch self {
        case .email:
            return .email
        case .phone:
            return .phone
        case .payPalId:
            return .payPalId
        case .userId:
            return .userId
        }
    }
}
