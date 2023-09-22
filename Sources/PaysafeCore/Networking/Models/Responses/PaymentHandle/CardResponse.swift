//
//  CardResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// CardResponse
struct CardResponse: Decodable {
    /// Card bin
    let cardBin: String?
    /// Network token
    let networkToken: NetworkToken?
}
