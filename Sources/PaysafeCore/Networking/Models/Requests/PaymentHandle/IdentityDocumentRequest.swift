//
//  IdentityDocumentRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// IdentityDocumentRequest
struct IdentityDocumentRequest: Encodable {
/// Type
#if DEBUG
    var type: String = "SOCIAL_SECURITY"
#else
    private let type: String = "SOCIAL_SECURITY"
#endif
    /// Document number
    let documentNumber: String
}
