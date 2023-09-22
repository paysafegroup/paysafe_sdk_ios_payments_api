//
//  CheckoutFieldView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CheckoutFieldView: View {
    let type: CheckoutFieldType

    var body: some View {
        HStack {
            titleView
            Spacer()
            detailView
        }
        .padding(16)
    }

    private var titleView: some View {
        PSText(type.title)
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.gray)
    }

    private var detailView: some View {
        HStack(spacing: 16) {
            PSText(type.detail)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(type.tintColor)
                .multilineTextAlignment(.trailing)
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 6, height: 10)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(type.tintColor)
        }
    }
}

struct CheckoutFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            Divider()
            CheckoutFieldView(type: .paymentMethod)
            Divider()
            CheckoutFieldView(type: .billingAddress(address: nil))
            Divider()
            CheckoutFieldView(type: .promoCode)
            Divider()
            CheckoutFieldView(type: .total(price: 0.99))
            Divider()
        }
    }
}
