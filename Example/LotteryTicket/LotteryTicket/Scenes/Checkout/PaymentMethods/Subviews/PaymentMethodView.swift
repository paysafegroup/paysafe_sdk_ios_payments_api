//
//  PaymentMethodView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct PaymentMethodView: View {
    let paymentMethod: PaymentMethod

    var body: some View {
        ZStack {
            containerView
            defaultContentView
        }
    }

    private var containerView: some View {
        Rectangle()
            .foregroundColor(.ltWhite)
            .border(Color.ltLightPurple)
    }

    private var defaultContentView: some View {
        HStack(spacing: 8) {
            Image(paymentMethod.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: paymentMethod.iconWidth)
            PSText(paymentMethod.title)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.ltDarkPurple)
            Spacer()
        }
        .padding(25)
    }
}

struct PaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodView(paymentMethod: .creditCard)
            .frame(height: 80)
            .padding(.horizontal, 16)
    }
}
