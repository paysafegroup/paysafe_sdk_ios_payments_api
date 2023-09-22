//
//  JWTRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

typealias SDKInfoRequest = SDKInfo
typealias ThreeDSCardDetailsRequest = ThreeDSCardDetails

struct JWTRequest: Encodable {
    /// Non-PCI card data
    let card: ThreeDSCardDetailsRequest
    /// Account id
    let accountId: String
    /// Cardinal SDK information
    let sdk: SDKInfoRequest

    /// - Parameters:
    ///   - card: ThreeDSCardDetails
    ///   - accountId: Account id
    init(
        card: ThreeDSCardDetailsRequest,
        accountId: String
    ) {
        self.card = card
        self.accountId = accountId
        sdk = .currentVersion
    }
}
