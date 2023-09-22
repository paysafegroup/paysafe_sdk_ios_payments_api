//
//  CheckoutBasicHeaderView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CheckoutBasicHeaderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            backButton
            titleView
            Spacer()
        }
        .padding(.top, 28)
    }

    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.ltDarkPurple)
        }
    }

    private var titleView: some View {
        PSText(title)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.ltDarkPurple)
    }
}

struct CheckoutBackHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutBasicHeaderView(title: "Title")
    }
}
