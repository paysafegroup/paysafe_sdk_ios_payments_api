//
//  ClientInfo.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Encapsulates the info related to Mobile SDK version & correlationId
struct ClientInfo: Encodable {
    /// App name
    let appName: String = "paysafe.ios.sdk"
    /// Version
    let version: String
    /// Correlation id
    let correlationId: String
    /// API key
    let apiKey: String
    /// Integration type
    let integrationType: IntegrationType

    /// - Parameters:
    ///   - version: Version
    ///   - correlationId: Correlation id
    ///   - apiKey: API key
    ///   - integrationType: IntegrationType
    init(
        version: String,
        correlationId: String,
        apiKey: String,
        integrationType: IntegrationType
    ) {
        self.version = version
        self.correlationId = correlationId
        self.apiKey = apiKey
        self.integrationType = integrationType
    }
}
