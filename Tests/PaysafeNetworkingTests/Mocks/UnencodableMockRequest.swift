//
//  UnencodableMockRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCommon

struct UnencodableMockRequest: Encodable {
    func encode(to encoder: Encoder) throws {
        throw PSError.encodingError("correlationId")
    }
}
