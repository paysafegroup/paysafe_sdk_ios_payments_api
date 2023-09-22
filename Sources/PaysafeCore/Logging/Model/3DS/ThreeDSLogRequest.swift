//
//  ThreeDSLogRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Log request for 3DS events
struct ThreeDSLogRequest: Encodable {
    /// Event type
    let eventType: ThreeDSEventType
    /// Event message
    let eventMessage: String
    /// SDK
    let sdk: ThreeDSClientInfo
}
