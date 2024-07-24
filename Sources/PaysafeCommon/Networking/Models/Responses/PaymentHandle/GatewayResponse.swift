//
//  GatewayResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// GatewayResponse
public struct GatewayResponse: Decodable {
    /// Id
    public let id: String?
    /// Client token
    public let clientToken: String?
    /// JWT token
    public let sessionToken: String?
    /// Processor
    public let processor: String?
}
