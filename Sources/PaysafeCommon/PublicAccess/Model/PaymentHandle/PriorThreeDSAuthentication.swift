//
//  PriorThreeDSAuthentication.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct PriorThreeDSAuthentication: Encodable {
    /// Data
    let data: String?
    /// 3DS authentication method
    let method: ThreeDSAuthentication?
    /// Id
    let id: String?
    /// Time
    let time: String?

    /// - Parameters:
    ///   - data: Data
    ///   - method: 3DS authentication method
    ///   - id: Id
    ///   - time: Time
    public init(
        data: String?,
        method: ThreeDSAuthentication?,
        id: String?,
        time: String?
    ) {
        self.data = data
        self.method = method
        self.id = id
        self.time = time
    }

    /// PriorThreeDSAuthenticationRequest
    var request: PriorThreeDSAuthenticationRequest {
        PriorThreeDSAuthenticationRequest(
            data: data,
            method: method?.request,
            id: id,
            time: time
        )
    }
}
