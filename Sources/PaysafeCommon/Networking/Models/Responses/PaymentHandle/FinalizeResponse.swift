//
//  FinalizeResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// FinalizeResponse
public struct FinalizeResponse: Decodable {
    /// Id
    public let id: String
    /// Device fingerprinting id
    public let deviceFingerprintingId: String
    /// Merchant reference number
    public let merchantRefNum: String
    /// 3DS result
    public let threeDResult: AuthenticationThreeDSResult
    /// Transaction time
    public let txnTime: String
    /// Directory server transaction id
    public let directoryServerTransactionId: String
    /// Amount
    public let amount: Double
    /// ECI
    public let eci: Double
    /// ACS url
    public let acsUrl: String
    /// Card
    public let card: CardResponse
    /// Merchant url
    public let merchantUrl: String
    /// CAVV
    public let cavv: String
    /// 3DS version
    public let threeDSecureVersion: String
    /// Currency
    public let currency: String
    /// Authentication status
    public let status: AuthenticationStatus
}
