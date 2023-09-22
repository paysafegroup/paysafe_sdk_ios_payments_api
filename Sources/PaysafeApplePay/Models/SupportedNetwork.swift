//
//  SupportedNetwork.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit

/// SupportedNetwork
public struct SupportedNetwork: Hashable {
    /// Supported network
    public let network: PKPaymentNetwork
    /// Supported network capability
    public let capability: CardTypeOption

    /// - Parameters:
    ///   - network: Supported network
    ///   - capability: Supported network capability
    public init(
        network: PKPaymentNetwork,
        capability: CardTypeOption
    ) {
        self.network = network
        self.capability = capability
    }
}
