//
//  JWTResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

typealias SDKInfoResponse = SDKInfo
typealias ThreeDSCardDetailsResponse = ThreeDSCardDetails

/// Response from the JWTRequest that enables the cardinal session to start
struct JWTResponse: Decodable {
    /// Response id
    let id: String
    /// Device fingerprinting ud
    let deviceFingerprintingId: String
    /// Account id
    let accountId: String
    /// JWT
    let jwt: String
    /// ThreeDSCardDetailsResponse
    let card: ThreeDSCardDetailsResponse
    /// SDKInfoResponse
    let sdk: SDKInfoResponse
}
