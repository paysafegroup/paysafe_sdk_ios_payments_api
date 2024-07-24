//
//  LogPayload.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Encapsulates the extra info related to current event to be logged for better understanding
struct LogPayload: Encodable {
    /// Message
    let message: String
}
