//
//  NetworkToken.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// NetworkToken received on saved cards
public struct NetworkToken: Decodable {
    /// Saved card bin
    public let bin: String
}
