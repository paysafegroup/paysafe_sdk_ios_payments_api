//
//  RequestorChallengePreference.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This indicates whether a challenge is requested for this transaction.
public enum RequestorChallengePreference: String, Encodable {
    /// Challenge mandated
    case challengeMandated = "CHALLENGE_MANDATED"
    /// Challenge requested
    case challengeRequested = "CHALLENGE_REQUESTED"
    /// No prefference
    case noPreference = "NO_PREFERENCE"

    /// RequestorChallengePreferenceRequest
    var request: RequestorChallengePreferenceRequest {
        switch self {
        case .challengeMandated:
            return .challengeMandated
        case .challengeRequested:
            return .challengeRequested
        case .noPreference:
            return .noPreference
        }
    }
}
