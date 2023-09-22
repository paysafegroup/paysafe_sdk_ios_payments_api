//
//  AuthenticationResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Authentication response
struct AuthenticationResponse: Decodable {
    /// Authentication status
    let status: AuthenticationStatus
    /// SDK challenge payload
    let sdkChallengePayload: String?
}
