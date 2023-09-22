//
//  ChallengePayloadOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ChallengePayloadOptions
struct ChallengePayloadOptions {
    /// Id received from the singleUsePayments response
    let id: String
    /// Merchant reference number
    let merchantRefNum: String
    /// Process
    let process: Bool?
}
