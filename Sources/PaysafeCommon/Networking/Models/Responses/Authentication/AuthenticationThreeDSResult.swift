//
//  AuthenticationThreeDSResult.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Authentication threeDS result
public enum AuthenticationThreeDSResult: String, Decodable {
    /// Y – The cardholder successfully authenticated with their card issuer.
    case authenticationSucceeded = "Y"
    /// A – The cardholder authentication was attempted.
    case authenticationAttempted = "A"
    /// N – The cardholder failed to successfully authenticate with their card issuer.
    case authenticationFailed = "N"
    /// U – Authentication with the card issuer was unavailable.
    case unavailable = "U"
    /// C – Challenge Required; additional authentication is required.
    case challengeRequired = "C"
    /// R – Rejected transaction.
    case rejected = "R"
}
