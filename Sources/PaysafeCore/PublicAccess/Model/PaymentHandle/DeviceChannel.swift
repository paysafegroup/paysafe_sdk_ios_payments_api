//
//  DeviceChannel.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the type of channel interface used to initiate the transaction
public enum DeviceChannel: String, Encodable {
    /// Browser
    case browser = "BROWSER"
    /// App
    case app = "APP"
    /// SDK
    case sdk = "SDK"
    /// 3RI
    case threeRi = "3RI"

    /// DeviceChannelRequest
    var request: DeviceChannelRequest {
        switch self {
        case .browser:
            return .browser
        case .app:
            return .app
        case .sdk:
            return .sdk
        case .threeRi:
            return .threeRi
        }
    }
}
