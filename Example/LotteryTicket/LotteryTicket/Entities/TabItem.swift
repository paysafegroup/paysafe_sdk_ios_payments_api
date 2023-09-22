//
//  TabItem.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Available tab items
enum TabItem: Int, CaseIterable {
    /// This case represents the `Home` tab
    case home
    /// This case represents the `Shop` tab
    case shop
    /// This case represents the `Cart` tab
    case cart
    /// This case represents the `Favourites` tab
    case favourites
    /// This case represents the `Options` tab
    case options

    /// Tab item icon name
    var iconName: String {
        switch self {
        case .home:
            return "home"
        case .shop:
            return "shop"
        case .cart:
            return "cart"
        case .favourites:
            return "favourites"
        case .options:
            return "options"
        }
    }
}
