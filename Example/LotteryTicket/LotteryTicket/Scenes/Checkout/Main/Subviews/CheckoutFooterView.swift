//
//  CheckoutFooterView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CheckoutFooterView: View {
    @Binding var showCheckout: Bool
    let canPlaceOrder: Bool
    let placeOrderHandler: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            disclaimerView
            itemButtonsView
        }
        .padding(.top, 16)
        .padding(.bottom, 10)
        .padding(.horizontal, 16)
    }

    private var disclaimerView: some View {
        VStack(spacing: 5) {
            PSText("By placing an order you agree to our")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.ltDarkPurple)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 5) {
                disclaimerButton(text: "Terms and Conditions") {}
                PSText("-")
                disclaimerButton(text: "Privacy Policy") {}
            }
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.ltPurple)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var itemButtonsView: some View {
        VStack(spacing: 5) {
            PSButton(title: "Place order", style: .primary, isEnabled: canPlaceOrder, action: placeOrderHandler)
            PSButton(title: "Cancel order", style: .tertiary) {
                showCheckout.toggle()
            }
        }
    }

    private func disclaimerButton(
        text: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            PSText(text)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CheckoutFooterView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(true) { CheckoutFooterView(showCheckout: $0, canPlaceOrder: true, placeOrderHandler: {}) }
    }
}
