//
//  ShopItemDetailInformationView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopItemDetailInformationView: View {
    @Binding var item: ShopItem?

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                itemTitleView
                Spacer()
                itemFavouriteView
            }

            HStack(spacing: 20) {
                itemPriceView
                itemDateView
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .padding(.top, 10)
    }

    private var itemTitleView: some View {
        PSText(item?.title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.ltDarkPurple)
    }

    private var itemFavouriteView: some View {
        Button {
            item?.favourite.toggle()
        } label: {
            Image(systemName: item?.favourite == true ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.ltDarkPurple)
        }
    }

    private var itemPriceView: some View {
        PSText(item?.priceString)
            .foregroundColor(.ltDarkPurple)
            .font(.system(size: 15, weight: .medium))
    }

    private var itemDateView: some View {
        PSText(item?.dateString)
            .font(.system(size: 14))
            .foregroundColor(.gray)
    }
}

struct ShopItemDetailInformationView_Previews: PreviewProvider {
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
        StatefulPreviewWrapper(shopItem) { ShopItemDetailInformationView(item: $0) }
    }
}
