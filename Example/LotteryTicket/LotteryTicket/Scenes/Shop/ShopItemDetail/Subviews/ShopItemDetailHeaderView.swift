//
//  ShopItemDetailHeaderView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopItemDetailHeaderView: View {
    @Binding var item: ShopItem?
    let geometry: GeometryProxy

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                PSBackgroundView(color: .ltGray)
                closeItemView
                itemIconView
                item?.newEntry == true ? itemNewEntryView : nil
            }
            PSDragView()
        }
        .frame(minHeight: geometry.size.height * (UIDevice.current.hasNotch ? 0.36 : 0.25))
    }

    private var closeItemView: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    item = nil
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.ltDarkPurple)
                }
                .padding(16)
            }
            .padding(.top, UIDevice.current.hasNotch ? 50 : 20)
            Spacer()
        }
    }

    private var itemIconView: some View {
        Image(item?.iconName ?? "")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.height * 0.18, height: geometry.size.height * 0.18)
    }

    private var itemNewEntryView: some View {
        VStack {
            Spacer()
            HStack {
                PSText("New")
                    .foregroundColor(.ltWhite)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 5)
                    .background(
                        Rectangle()
                            .fill(Color.ltPurple.opacity(0.85))
                    )
                Spacer()
            }
            .padding(16)
        }
    }
}

struct ShopItemDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let shopItem = ShopItem(id: 0,
                                title: "Draw Games",
                                description: "Draw Games offer an exhilarating opportunity to test your luck and win big by selecting a set of numbers for a chance to match those drawn in the upcoming game. With each ticket, you hold the potential to unlock a jackpot that could turn your dreams into reality.",
                                price: 0.99,
                                date: Date(),
                                iconName: "calendar",
                                favourite: true,
                                newEntry: true,
                                availableQuantity: 10)
        GeometryReader { geometry in
            StatefulPreviewWrapper(shopItem) { ShopItemDetailHeaderView(item: $0, geometry: geometry) }
        }
    }
}
