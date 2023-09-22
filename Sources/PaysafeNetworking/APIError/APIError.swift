//
//  APIError.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// APIError object used to decode the error object received from the backend.
public struct APIError: Error, Decodable {
    /// Error
    public let error: ErrorDetails
}
