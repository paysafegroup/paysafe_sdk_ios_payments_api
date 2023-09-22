//
//  IntegrationType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Type of the integration Mobile SDK is initialized
enum IntegrationType: String, Encodable {
    /// Payments API type
    case paymentsApi = "PAYMENTS_API"
    /// Standalone 3ds type
    case standAlone3DS = "STANDALONE_3DS"
}
