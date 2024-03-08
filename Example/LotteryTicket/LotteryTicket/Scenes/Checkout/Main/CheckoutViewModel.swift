//
//  CheckoutViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

final class CheckoutViewModel: ObservableObject {
    @Published private(set) var placeOrderEnabled = false
    @Binding private(set) var showCheckout: Bool
    @Published var billingAddress: BillingAddress?

    let item: ShopItem?
    let selectedQuantity: Int

    private var isFirstLaunch = true

    var totalPrice: Double {
        guard let price = item?.price else { return 0.0 }
        return price * Double(selectedQuantity)
    }

    init(
        showCheckout: Binding<Bool>,
        item: ShopItem?,
        selectedQuantity: Int
    ) {
        _showCheckout = showCheckout
        self.item = item
        self.selectedQuantity = selectedQuantity
    }

    func onAppear() {
        configureSavedData()
    }

    func didTapPlaceOrder() {
        print("Place order")
    }

    private func configureSavedData() {
        guard isFirstLaunch else { return }
        isFirstLaunch = false
        billingAddress = BillingAddress(
            nickName: "John Doe",
            street: "5335 Gate Parkway Fourth Floor",
            city: "Jacksonvillle",
            state: "FL",
            country: "US",
            zip: "32256"
        )
    }
}
