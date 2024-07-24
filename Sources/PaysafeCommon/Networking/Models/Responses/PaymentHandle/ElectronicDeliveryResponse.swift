//
//  ElectronicDeliveryResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ElectronicDeliveryResponse
struct ElectronicDeliveryResponse: Decodable {
    /// Is electronic delivery
    let isElectronicDelivery: Bool?
    /// Email
    let email: String?
}
