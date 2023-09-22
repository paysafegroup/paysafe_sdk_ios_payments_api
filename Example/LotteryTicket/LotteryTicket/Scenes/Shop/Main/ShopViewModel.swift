//
//  ShopViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

final class ShopViewModel: ObservableObject {
    let categories: [ShopCategory]
    @Published var selectedCategory: ShopCategory?

    init() {
        categories = ShopCategory.allCases
    }

    func select(category: ShopCategory) {
        selectedCategory = category
    }
}
