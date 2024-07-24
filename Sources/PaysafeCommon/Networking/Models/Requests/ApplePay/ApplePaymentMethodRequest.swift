//
//  ApplePaymentMethodRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentMethodRequest
public struct ApplePaymentMethodRequest: Encodable {
    /// Display name
    let displayName: String?
    /// Network
    let network: String?
    /// Type
    let type: String
    
    public init(displayName: String?, network: String?, type: String) {
        self.displayName = displayName
        self.network = network
        self.type = type
    }
}
