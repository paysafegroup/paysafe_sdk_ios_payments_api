//
//  UserLoginRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

typealias AuthenticationMethodRequest = InternalAuthenticationMethod

/// UserLoginRequest
struct UserLoginRequest: Encodable {
    /// Data
    let data: String?
    /// Authentication method
    let authenticationMethod: AuthenticationMethodRequest?
    /// Time
    let time: String?
}
