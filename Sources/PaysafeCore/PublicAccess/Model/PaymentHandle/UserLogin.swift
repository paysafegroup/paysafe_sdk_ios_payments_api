//
//  UserLogin.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct UserLogin: Encodable {
    /// Data
    let data: String?
    /// Authentication method
    let authenticationMethod: AuthenticationMethod?
    /// Time
    let time: String?

    /// - Parameters:
    ///   - data: Data
    ///   - authenticationMethod: Authentication method
    ///   - time: Time
    public init(
        data: String?,
        authenticationMethod: AuthenticationMethod?,
        time: String?
    ) {
        self.data = data
        self.authenticationMethod = authenticationMethod
        self.time = time
    }

    /// UserLoginRequest
    var request: UserLoginRequest {
        UserLoginRequest(
            data: data,
            authenticationMethod: authenticationMethod?.request,
            time: time
        )
    }
}
