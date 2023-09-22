//
//  CheckoutView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CheckoutView<ViewModel: CheckoutViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    init(
        showCheckout: Binding<Bool>,
        item: ShopItem?,
        selectedQuantity: Int
    ) {
        viewModel = ViewModel(
            showCheckout: showCheckout,
            item: item,
            selectedQuantity: selectedQuantity
        )
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CheckoutHeaderView(
                        showCheckout: viewModel.$showCheckout
                    )
                    CheckoutItemDetailsView(
                        item: viewModel.item
                    )
                    CheckoutFormView(
                        billingAddress: $viewModel.billingAddress,
                        item: viewModel.item,
                        totalPrice: viewModel.totalPrice
                    )
                    CheckoutFooterView(
                        showCheckout: viewModel.$showCheckout,
                        canPlaceOrder: viewModel.placeOrderEnabled
                    ) {
                        viewModel.didTapPlaceOrder()
                    }
                }
            }
            .onAppear { viewModel.onAppear() }
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        let shopItem = ShopItem(
            id: 0,
            title: "Draw Games",
            description: "Draw Games offer an exhilarating opportunity to test your luck and win big by selecting a set of numbers for a chance to match those drawn in the upcoming game. With each ticket, you hold the potential to unlock a jackpot that could turn your dreams into reality.",
            price: 0.99,
            date: Date(),
            iconName: "calendar",
            favourite: true,
            newEntry: true,
            availableQuantity: 10
        )
        StatefulPreviewWrapper(true) {
            CheckoutView(
                showCheckout: $0,
                item: shopItem,
                selectedQuantity: 1
            )
        }
    }
}
