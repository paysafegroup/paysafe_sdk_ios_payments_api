//
//  UnencodableMockRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

public struct UnencodableMockRequest: Encodable {
    public func encode(to encoder: Encoder) throws {
        throw PSError.encodingError("correlationId")
    }
}
