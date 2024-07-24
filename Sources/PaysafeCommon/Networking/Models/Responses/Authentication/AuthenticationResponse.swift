//
//  AuthenticationResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Authentication response
public struct AuthenticationResponse: Decodable {
    /// Authentication status
    public let status: AuthenticationStatus
    /// SDK challenge payload
    public let sdkChallengePayload: String?
}
