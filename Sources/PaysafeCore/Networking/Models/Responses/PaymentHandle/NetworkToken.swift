//
//  NetworkToken.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// NetworkToken received on saved cards
struct NetworkToken: Decodable {
    /// Saved card bin
    let bin: String
}
