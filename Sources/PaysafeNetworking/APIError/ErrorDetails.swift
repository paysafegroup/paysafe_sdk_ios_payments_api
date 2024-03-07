//
//  ErrorDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// API error details used to decode the error object details received from the backend.
public struct ErrorDetails: Decodable {
    /// Error code
    public let code: String
    /// Error message
    public let message: String
}
