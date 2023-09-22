//
//  Paysafe3DSOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

public struct Paysafe3DSOptions {
    /// Account id
    let accountId: String
    /// Card bin
    let cardBin: String

    /// - Parameters:
    ///   - accountId: Account id
    ///   - cardBin: Card bin
    public init(
        accountId: String,
        cardBin: String
    ) {
        self.accountId = accountId
        self.cardBin = cardBin
    }
}
