//
//  GatewayResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// GatewayResponse
struct GatewayResponse: Decodable {
    /// Id
    let id: String?
    /// Client token
    let clientToken: String?
    /// JWT token
    let jwtToken: String?
    /// Processor
    let processor: String?
}
