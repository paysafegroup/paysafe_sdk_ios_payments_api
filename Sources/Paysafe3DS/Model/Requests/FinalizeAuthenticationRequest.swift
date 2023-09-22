//
//  FinalizeAuthenticationRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Finalize authentication request
struct FinalizeAuthenticationRequest: Encodable {
    /// ServerJWT Payload
    let payload: String
}
