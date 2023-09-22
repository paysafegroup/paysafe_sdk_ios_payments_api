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
    let accountId: String
    /// Card bin
    let bin: String

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
