//
//  SDKChallengePayload.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

struct SDKChallengePayload: Codable {
    /// Id
    let id: String
    /// Transaction id
    let transactionId: String
    /// Payload
    let payload: String
    /// Account id
    let accountId: String

    /// Decode payload string into SDKChallengePayload
    static func challenge(from payloadString: String?) -> SDKChallengePayload? {
        guard let payloadString,
              let payloadData = Data(base64Encoded: payloadString),
              let challengePayload = try? JSONDecoder().decode(SDKChallengePayload.self, from: payloadData) else { return nil }
        return challengePayload
    }
}
