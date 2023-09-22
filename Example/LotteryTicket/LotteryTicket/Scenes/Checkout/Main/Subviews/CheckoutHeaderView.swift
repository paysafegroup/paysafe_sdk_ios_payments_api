//
//  CheckoutHeaderView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CheckoutHeaderView: View {
    @Binding var showCheckout: Bool

    var body: some View {
        HStack {
            titleView
            Spacer()
            closeCheckoutView
        }
        .padding(.top, 28)
        .padding(.horizontal, 16)
    }

    private var closeCheckoutView: some View {
        Button {
            showCheckout.toggle()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.ltDarkPurple)
        }
    }

    private var titleView: some View {
        PSText("Checkout")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.ltDarkPurple)
    }
}

struct CheckoutHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(true) { CheckoutHeaderView(showCheckout: $0) }
    }
}
