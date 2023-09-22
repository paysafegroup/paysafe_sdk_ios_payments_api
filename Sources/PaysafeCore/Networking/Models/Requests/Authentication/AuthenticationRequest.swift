//
//  AuthenticationRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Authentication request
struct AuthenticationRequest: Encodable {
    /// Device fingerprinting id
    let deviceFingerprintingId: String
    /// Merchant reference number
    let merchantRefNum: String
    /// Process
    let process: Bool?
}
