//
//  IdentityDocument.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct IdentityDocument: Encodable {
    /// Document number. Should not exceed 9 characters.
    public let documentNumber: String

    public init(documentNumber: String) {
        self.documentNumber = documentNumber
    }

    var request: IdentityDocumentRequest {
        .init(documentNumber: documentNumber)
    }
}
