//
//  DeviceChannelRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the type of channel interface used to initiate the transaction
enum DeviceChannelRequest: String, Encodable {
    case sdk = "SDK"
}
