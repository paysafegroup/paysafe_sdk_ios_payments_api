//
//  UserLoginResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

typealias AuthenticationMethodResponse = InternalAuthenticationMethod

/// UserLoginResponse
struct UserLoginResponse: Decodable {
    /// Data
    let data: String?
    /// Authentication method
    let authenticationMethod: AuthenticationMethodResponse?
    /// Time
    let time: String?
}
