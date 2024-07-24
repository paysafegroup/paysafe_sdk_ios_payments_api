//
//  PriorThreeDSAuthenticationRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PriorThreeDSAuthenticationRequest
struct PriorThreeDSAuthenticationRequest: Encodable {
    /// Data
    let data: String?
    /// 3DS authentication method
    let method: ThreeDSAuthenticationRequest?
    /// Id
    let id: String?
    /// Time
    let time: String?
}
