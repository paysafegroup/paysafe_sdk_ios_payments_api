//
//  CheckoutFormView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CheckoutFormView: View {
    @Binding var billingAddress: BillingAddress?
    let item: ShopItem?
    let totalPrice: Double

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            paymentMethodFieldView
            Divider()
            billingAddressFieldView
            Divider()
            promoCodeFieldView
            Divider()
            totalPriceFieldView
            Divider()
        }
    }

    private var paymentMethodFieldView: some View {
        NavigationLink(
            destination: NavigationLazyView(
                PaymentMethodsView(
                    billingAddress: billingAddress,
                    item: item,
                    totalPrice: totalPrice
                )
            )
        ) {
            CheckoutFieldView(type: .paymentMethod)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier("paymentMethodFieldView")
    }

    private var billingAddressFieldView: some View {
        CheckoutFieldView(type: .billingAddress(address: billingAddress))
    }

    private var promoCodeFieldView: some View {
        CheckoutFieldView(type: .promoCode)
    }

    private var totalPriceFieldView: some View {
        CheckoutFieldView(type: .total(price: totalPrice))
    }
}

struct CheckoutFormView_Previews: PreviewProvider {
    static var previews: some View {
        let billingAddress = BillingAddress(
            nickName: "CARLOS\nMONGE BONILLA",
            street: "11350 NW 25TH ST",
            city: "SWEETWATER",
            state: "FL",
            country: "US",
            zip: "33172"
        )
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
        StatefulPreviewWrapper(billingAddress) {
            CheckoutFormView(
                billingAddress: $0,
                item: shopItem,
                totalPrice: 0.99
            )
        }
    }
}
