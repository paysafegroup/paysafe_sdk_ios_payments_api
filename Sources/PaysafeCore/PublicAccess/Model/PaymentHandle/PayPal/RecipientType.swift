//
//  RecipientType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// RecipientType
public enum RecipientType: Encodable {
    /// Only supported value
    case payPalId

    /// RecipientTypeRequest
    var request: RecipientTypeRequest {
        .payPalId
    }
}
