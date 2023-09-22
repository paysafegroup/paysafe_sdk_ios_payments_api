//
//  ShopItemDetailViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

final class ShopItemDetailViewModel: ObservableObject {
    @Binding private(set) var item: ShopItem?
    @Published var showCheckout = false
    @Published var selectedQuantity = 1

    var checkoutEnabled: Bool {
        guard let availableQuantity = item?.availableQuantity else { return false }
        return availableQuantity > 0
    }

    init(item: Binding<ShopItem?>) {
        _item = item
    }

    func dismiss() {
        item = nil
    }
}
