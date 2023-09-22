//
//  CheckoutItemDetailsView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CheckoutItemDetailsView: View {
    let item: ShopItem?

    var body: some View {
        HStack(spacing: 16) {
            itemIconView
            VStack(alignment: .leading, spacing: 5) {
                itemTitleView
                itemDateView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }

    private var itemIconView: some View {
        ZStack {
            PSBackgroundView(color: .ltGray)
            Image(item?.iconName ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
        .frame(width: 50, height: 50)
    }

    private var itemTitleView: some View {
        PSText(item?.title)
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.ltDarkPurple)
    }

    private var itemDateView: some View {
        PSText(item?.dateString)
            .font(.system(size: 17))
            .foregroundColor(.gray)
    }
}

struct CheckoutItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let shopItem = ShopItem(id: 0,
                                title: "Draw Games",
                                description: "Draw Games offer an exhilarating opportunity to test your luck and win big by selecting a set of numbers for a chance to match those drawn in the upcoming game. With each ticket, you hold the potential to unlock a jackpot that could turn your dreams into reality.",
                                price: 0.99,
                                date: Date(),
                                iconName: "calendar",
                                favourite: true,
                                newEntry: false,
                                availableQuantity: 10)
        CheckoutItemDetailsView(item: shopItem)
    }
}
