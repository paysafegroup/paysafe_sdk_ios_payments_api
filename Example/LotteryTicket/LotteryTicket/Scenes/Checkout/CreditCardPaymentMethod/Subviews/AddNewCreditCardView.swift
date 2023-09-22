//
//  AddNewCreditCardView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct AddNewCreditCardView: View {
    var body: some View {
        ZStack {
            containerView
            contentView
        }
    }

    private var containerView: some View {
        Rectangle()
            .foregroundColor(.ltWhite)
            .border(Color.ltLightPurple)
    }

    private var contentView: some View {
        HStack(spacing: 8) {
            Image("plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            PSText("Add New Card")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.ltDarkPurple)
            Spacer()
        }
        .padding(25)
    }
}

struct AddNewCreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCreditCardView()
            .frame(height: 80)
            .padding(16)
    }
}
