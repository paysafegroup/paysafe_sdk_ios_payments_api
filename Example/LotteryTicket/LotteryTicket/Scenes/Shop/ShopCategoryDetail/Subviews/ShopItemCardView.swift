//
//  ShopItemCardView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopItemCardView: View {
    let item: ShopItem
    let geometryHeight: CGFloat
    let selectionHandler: () -> Void
    let favouriteHandler: () -> Void

    var body: some View {
        Button {
            selectionHandler()
        } label: {
            itemContentView
        }
        .frame(height: geometryHeight)
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier("shopItemCardView\(item.id)")
    }

    private var itemContentView: some View {
        ZStack {
            PSBackgroundView(color: .ltGray)
            itemDetailsView
            itemImageView
            itemFavouriteView
        }
    }

    private var itemDetailsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            itemExtraDetailsView
            itemTitleView
            itemDateView
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var itemExtraDetailsView: some View {
        VStack(alignment: .leading, spacing: 4) {
            item.newEntry ? itemNewEntryView : nil
            itemPriceView
        }
    }

    private var itemTitleView: some View {
        PSText(item.title)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.ltDarkPurple)
    }

    private var itemDateView: some View {
        PSText(item.dateString)
            .font(.system(size: 14))
            .foregroundColor(.gray)
    }

    private var itemNewEntryView: some View {
        PSText("New")
            .foregroundColor(.ltWhite)
            .font(.system(size: 12, weight: .medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 5)
            .background(
                Rectangle()
                    .fill(Color.ltPurple.opacity(0.85))
            )
    }

    private var itemPriceView: some View {
        PSText(item.priceString)
            .foregroundColor(.ltDarkPurple)
            .font(.system(size: 15, weight: .medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 5)
            .background(
                Rectangle()
                    .fill(Color.ltWhite)
            )
    }

    private var itemImageView: some View {
        Image(item.iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometryHeight * 0.275, height: geometryHeight * 0.275)
            .offset(y: -geometryHeight * 0.15)
    }

    private var itemFavouriteView: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    favouriteHandler()
                } label: {
                    Image(systemName: item.favourite ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.ltDarkPurple)
                }
                .padding(16)
            }
            Spacer()
        }
    }
}

struct ShopItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ShopItemCardView(
            item: ShopItem(
                id: 0,
                title: "Draw Games",
                description: "Draw Games offer an exhilarating opportunity to test your luck and win big by selecting a set of numbers for a chance to match those drawn in the upcoming game. With each ticket, you hold the potential to unlock a jackpot that could turn your dreams into reality.",
                price: 0.99,
                date: Date(),
                iconName: "calendar",
                favourite: true,
                newEntry: false,
                availableQuantity: 10
            ),
            geometryHeight: 200,
            selectionHandler: {},
            favouriteHandler: {}
        )
    }
}
