//
//  PriorThreeDSAuthenticationResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PriorThreeDSAuthenticationResponse
struct PriorThreeDSAuthenticationResponse: Decodable {
    /// Date
    let data: String?
    /// 3DS authentication method
    let method: ThreeDSAuthenticationResponse?
    /// Id
    let id: String?
    /// Time
    let time: String?
}
