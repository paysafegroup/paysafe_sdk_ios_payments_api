//
//  AuthenticationStatus.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public enum AuthenticationStatus: String, Decodable {
    /// Completed
    case completed = "COMPLETED"
    /// Pending
    case pending = "PENDING"
    /// Failed
    case failed = "FAILED"
}
