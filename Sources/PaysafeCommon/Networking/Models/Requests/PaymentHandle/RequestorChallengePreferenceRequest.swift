//
//  RequestorChallengePreferenceRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Indicates whether a challenge is requested for this transaction.
public enum RequestorChallengePreferenceRequest: String, Encodable {
    /// Challenge mandated
    case challengeMandated = "CHALLENGE_MANDATED"
    // Challenge requested
    case challengeRequested = "CHALLENGE_ REQUESTED"
    /// No preference
    case noPreference = "NO_PREFERENCE"
}
