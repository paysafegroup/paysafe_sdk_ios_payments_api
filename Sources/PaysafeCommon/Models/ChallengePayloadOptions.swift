//
//  ChallengePayloadOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ChallengePayloadOptions
public struct ChallengePayloadOptions {
    /// Id received from the singleUsePayments response
    public let id: String
    /// Merchant reference number
    public let merchantRefNum: String
    /// Process
    public let process: Bool?
    
    public init(id: String, merchantRefNum: String, process: Bool?) {
        self.id = id
        self.merchantRefNum = merchantRefNum
        self.process = process
    }
}
