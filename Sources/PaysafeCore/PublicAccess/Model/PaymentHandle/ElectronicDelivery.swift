//
//  ElectronicDelivery.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct ElectronicDelivery: Encodable {
    /// Is electronic delivery
    let isElectronicDelivery: Bool
    /// Email
    let email: String

    /// - Parameters:
    ///   - isElectronicDelivery: Is electronic delivery
    ///   - email: Email
    public init(
        isElectronicDelivery: Bool,
        email: String
    ) {
        self.isElectronicDelivery = isElectronicDelivery
        self.email = email
    }

    /// ElectronicDeliveryRequest
    var request: ElectronicDeliveryRequest {
        ElectronicDeliveryRequest(
            isElectronicDelivery: isElectronicDelivery,
            email: email
        )
    }
}
