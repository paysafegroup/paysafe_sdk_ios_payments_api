//
//  CardResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// CardResponse
public struct CardResponse: Decodable {
    /// Card bin
    public let cardBin: String?
    /// Network token
    public let networkToken: NetworkToken?
}
