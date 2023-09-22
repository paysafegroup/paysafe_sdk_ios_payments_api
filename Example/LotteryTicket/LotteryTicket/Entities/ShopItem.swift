//
//  ShopItem.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

struct ShopItem: Hashable, Identifiable {
    /// Shop item id
    let id: Int
    /// Shop item title
    let title: String
    /// Shop item description
    let description: String
    /// Shop item price
    let price: Double
    /// Shop item date
    let date: Date
    /// Shop item icon name
    let iconName: String
    /// Shop item favourite flag
    var favourite: Bool
    /// Shop item new entry flag
    let newEntry: Bool
    /// Shop item available quantity
    let availableQuantity: Int

    /// Formated date stirng
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy - ha"
        return formatter.string(from: date)
    }

    /// Formated price string
    var priceString: String {
        String(format: "$%.2f", price)
    }
}
