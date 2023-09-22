//
//  ThreeDSCardDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

struct ThreeDSCardDetails: Codable {
    /// Card bin
    let cardBin: String
    /// Payment token
    let paymentToken: String?

    /// - Parameters:
    ///   - cardBin: Card bin
    ///   - paymentToken: Payment token
    init(
        cardBin: String,
        paymentToken: String? = nil
    ) {
        self.cardBin = cardBin
        self.paymentToken = paymentToken
    }
}
