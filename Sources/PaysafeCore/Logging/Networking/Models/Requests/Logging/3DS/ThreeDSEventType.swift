//
//  ThreeDSEventType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Type of the 3DS logging event. Permitted Values are (INTERNAL_SDK_ERROR)
enum ThreeDSEventType: String, Encodable {
    /// INTERNAL_SDK_ERROR type
    case internalSDKError = "INTERNAL_SDK_ERROR"
    /// VALIDATION_ERROR type
    case validationError = "VALIDATION_ERROR"
    /// SUCCESS type
    case success = "SUCCESS"
    /// NETWORK_ERROR type
    case networkError = "NETWORK_ERROR"
}
