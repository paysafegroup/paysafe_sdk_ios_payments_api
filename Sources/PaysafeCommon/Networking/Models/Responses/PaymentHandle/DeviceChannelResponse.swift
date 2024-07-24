//
//  DeviceChannelResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the type of channel interface used to initiate the transaction
enum DeviceChannelResponse: String, Decodable {
    /// Browser
    case browser = "BROWSER"
    /// App
    case app = "APP"
    /// SDK
    case sdk = "SDK"
    /// 3RI
    case threeRi = "3RI"
}
