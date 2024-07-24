//
//  LogRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Log request for events
struct LogRequest: Encodable {
    /// Event type
    let type: EventType
    /// Client info
    let clientInfo: ClientInfo
    /// Log payload
    let payload: LogPayload
}
