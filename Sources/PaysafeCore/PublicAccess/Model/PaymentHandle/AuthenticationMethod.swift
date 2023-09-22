//
//  AuthenticationMethod.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the mechanism used by the cardholder to authenticate to the 3DS Requestor.
public enum AuthenticationMethod: String, Encodable {
    /// Third party authentication
    case thirdPartyAuthentication = "THIRD_PARTY_AUTHENTICATION"
    /// No login
    case noLogin = "NO_LOGIN"
    /// Internal credentials
    case internalCredentials = "INTERNAL_CREDENTIALS"
    /// Federated id
    case federatedId = "FEDERATED_ID"
    /// Issuer credentials
    case issuerCredentials = "ISSUER_CREDENTIALS"
    /// FIDO authenticator
    case fidoAuthenticator = "FIDO_AUTHENTICATOR"

    /// AuthenticationMethodRequest
    var request: AuthenticationMethodRequest {
        switch self {
        case .thirdPartyAuthentication:
            return .thirdPartyAuthentication
        case .noLogin:
            return .noLogin
        case .internalCredentials:
            return .internalCredentials
        case .federatedId:
            return .federatedId
        case .issuerCredentials:
            return .issuerCredentials
        case .fidoAuthenticator:
            return .fidoAuthenticator
        }
    }
}
