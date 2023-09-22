//
//  FinalizeAuthenticationOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Finalize authentication options
struct FinalizeAuthenticationOptions {
    /// Account id
    let accountId: String
    /// Authentication response id
    let authenticationId: String
    /// Server JWT
    let serverJWT: String
}
