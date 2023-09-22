//
//  SplitPayRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// SplitPayRequest
struct SplitPayRequest: Encodable {
    /// Linked account
    let linkedAccount: String
    /// Amount
    let amount: Int?
    /// Percent
    let percent: Int?
}
