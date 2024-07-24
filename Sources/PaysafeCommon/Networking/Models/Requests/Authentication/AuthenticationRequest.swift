//
//  AuthenticationRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Authentication request
public struct AuthenticationRequest: Encodable {
    /// Device fingerprinting id
    public let deviceFingerprintingId: String
    /// Merchant reference number
    public let merchantRefNum: String
    /// Process
    public let process: Bool?

    public init(deviceFingerprintingId: String, merchantRefNum: String, process: Bool?) {
        self.deviceFingerprintingId = deviceFingerprintingId
        self.merchantRefNum = merchantRefNum
        self.process = process
    }
}
