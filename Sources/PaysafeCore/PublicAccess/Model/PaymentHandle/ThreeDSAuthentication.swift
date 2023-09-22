//
//  ThreeDSAuthentication.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the mechanism used previously by the cardholder to authenticate to the 3DS Requestor.
public enum ThreeDSAuthentication: String, Encodable {
    /// Frictionless authentication
    case frictionlessAuthentication = "FRICTIONLESS_AUTHENTICATION"
    /// ACS challenge
    case acsChallenge = "ACS_CHALLENGE"
    /// AVS verified
    case avsVerified = "AVS_VERIFIED"
    /// Other issuer method
    case otherIssuerMethod = "OTHER_ISSUER_METHOD"

    /// ThreeDSAuthenticationRequest
    var request: ThreeDSAuthenticationRequest {
        switch self {
        case .frictionlessAuthentication:
            return .frictionlessAuthentication
        case .acsChallenge:
            return .acsChallenge
        case .avsVerified:
            return .avsVerified
        case .otherIssuerMethod:
            return .otherIssuerMethod
        }
    }
}
