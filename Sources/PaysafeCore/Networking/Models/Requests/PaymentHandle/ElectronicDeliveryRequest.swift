//
//  ElectronicDeliveryRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ElectronicDeliveryRequest
struct ElectronicDeliveryRequest: Encodable {
    /// Is electronic delivery
    let isElectronicDelivery: Bool
    /// Email
    let email: String
}
