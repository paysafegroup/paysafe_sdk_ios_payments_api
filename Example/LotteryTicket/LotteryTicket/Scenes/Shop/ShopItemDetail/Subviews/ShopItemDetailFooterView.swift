//
//  ShopItemDetailFooterView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopItemDetailFooterView: View {
    @Binding var showCheckout: Bool
    let enabledCheckout: Bool

    var body: some View {
        VStack(spacing: 10) {
            itemButtonsView
            itemPaymentMethodsView
        }
        .padding(.horizontal, 16)
    }

    private var itemButtonsView: some View {
        VStack(spacing: 16) {
            PSButton(
                title: "Add to bag",
                style: .secondary,
                isEnabled: enabledCheckout
            ) {}
                .accessibilityIdentifier("addToBagButton")
            PSButton(
                title: "Buy it now",
                style: .primary,
                isEnabled: enabledCheckout
            ) {
                showCheckout.toggle()
            }
            .accessibilityIdentifier("buyItNowButton")
        }
    }

    private var itemPaymentMethodsView: some View {
        Image("paymentMethods")
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ShopItemDetailFooterView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(false) {
            ShopItemDetailFooterView(
                showCheckout: $0,
                enabledCheckout: true
            )
        }
    }
}
