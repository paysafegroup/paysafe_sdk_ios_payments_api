//
//  ShopItemDetailView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopItemDetailView<ViewModel: ShopItemDetailViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    init(item: Binding<ShopItem?>) {
        viewModel = ViewModel(item: item)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ShopItemDetailHeaderView(
                    item: viewModel.$item,
                    geometry: geometry
                )
                ShopItemDetailInformationView(
                    item: viewModel.$item
                )
                ShopItemDetailQuantityView(
                    selectedQuantity: $viewModel.selectedQuantity,
                    availableQuantity: viewModel.item?.availableQuantity,
                    geometry: geometry
                )
                ShopItemDetailDescriptionView(
                    item: viewModel.item
                )
                ShopItemDetailFooterView(
                    showCheckout: $viewModel.showCheckout,
                    enabledCheckout: viewModel.checkoutEnabled
                )
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 50 {
                            viewModel.dismiss()
                        }
                    }
            )
        }
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $viewModel.showCheckout) {
            if #available(iOS 16.0, *) {
                CheckoutView(
                    showCheckout: $viewModel.showCheckout,
                    item: viewModel.item,
                    selectedQuantity: viewModel.selectedQuantity
                )
                .presentationDetents([.fraction(UIDevice.current.hasNotch ? 0.8 : 0.96)])
                .interactiveDismissDisabled()
            } else {
                CheckoutView(
                    showCheckout: $viewModel.showCheckout,
                    item: viewModel.item,
                    selectedQuantity: viewModel.selectedQuantity
                )
            }
        }
    }
}

struct ShopItemDetailView_Previews: PreviewProvider {
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
        StatefulPreviewWrapper(shopItem) { ShopItemDetailView(item: $0) }
    }
}
