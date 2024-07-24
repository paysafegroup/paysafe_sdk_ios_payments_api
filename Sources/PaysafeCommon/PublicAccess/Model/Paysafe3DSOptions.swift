//
//  Paysafe3DSOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Paysafe3DS options
public struct Paysafe3DSOptions {
    /// Account id
    public let accountId: String
    /// Card bin
    public let bin: String

    /// - Parameters:
    ///   - accountId: Account id
    ///   - bin: Card bin
    public init(
        accountId: String,
        bin: String
    ) {
        self.accountId = accountId
        self.bin = bin
    }
}
