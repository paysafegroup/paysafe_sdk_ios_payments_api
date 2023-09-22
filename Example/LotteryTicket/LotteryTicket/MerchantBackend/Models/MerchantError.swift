//
//  MerchantError.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

/// MerchantError
enum MerchantError: Error {
    /// Network error
    case networkError(Error)
    /// Data error
    case dataError
    /// Other error
    case other(Error)
}
