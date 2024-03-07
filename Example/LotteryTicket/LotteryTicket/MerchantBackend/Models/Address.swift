//
//  Address.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

/// Address
struct Address: Decodable {
    /// Id
    let id: String?
    /// Nickname
    let nickName: String?
    /// City
    let city: String?
    /// State
    let state: String?
    /// Country
    let country: String?
    /// Zip
    let zip: String?
    /// Status
    let status: String?
    /// Street
    let street: String?
}
