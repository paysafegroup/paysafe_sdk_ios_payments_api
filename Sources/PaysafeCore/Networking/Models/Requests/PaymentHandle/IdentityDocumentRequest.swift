//
//  IdentityDocumentRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// IdentityDocumentRequest
struct IdentityDocumentRequest: Encodable {
    /// Type
    let type: String
    /// Document number
    let documentNumber: String
}
