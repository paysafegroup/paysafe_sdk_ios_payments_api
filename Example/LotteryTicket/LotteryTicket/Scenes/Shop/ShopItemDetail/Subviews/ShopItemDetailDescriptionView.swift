//
//  ShopItemDetailDescriptionView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopItemDetailDescriptionView: View {
    let item: ShopItem?

    var body: some View {
        VStack(spacing: 8) {
            PSText("Description")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            PSText(item?.description)
                .font(.system(size: 17, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
        }
        .foregroundColor(.ltDarkPurple)
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
}

struct ShopItemDetailDescriptionView_Previews: PreviewProvider {
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
        ShopItemDetailDescriptionView(item: shopItem)
    }
}
