//
//  PSThreeDSEvent.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// 3DS Event sent for logging
struct PSThreeDSEvent {
    /// 3DS event type
    let type: ThreeDSEventType
    /// 3DS event message
    let message: String
}
