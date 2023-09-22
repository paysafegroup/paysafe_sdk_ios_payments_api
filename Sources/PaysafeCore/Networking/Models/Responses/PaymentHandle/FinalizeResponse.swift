//
//  FinalizeResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// FinalizeResponse
struct FinalizeResponse: Decodable {
    /// Id
    let id: String
    /// Device fingerprinting id
    let deviceFingerprintingId: String
    /// Merchant reference number
    let merchantRefNum: String
    /// 3DS result
    let threeDResult: AuthenticationThreeDSResult
    /// Transaction time
    let txnTime: String
    /// Directory server transaction id
    let directoryServerTransactionId: String
    /// Amount
    let amount: Double
    /// ECI
    let eci: Double
    /// ACS url
    let acsUrl: String
    /// Card
    let card: CardResponse
    /// Merchant url
    let merchantUrl: String
    /// CAVV
    let cavv: String
    /// 3DS version
    let threeDSecureVersion: String
    /// Currency
    let currency: String
    /// Authentication status
    let status: AuthenticationStatus
}
