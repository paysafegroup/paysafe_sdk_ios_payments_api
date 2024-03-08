//
//  ShopCategoryView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopCategoryView: View {
    var category: ShopCategory
    var geometryHeight: CGFloat
    var selectionHandler: () -> Void

    var body: some View {
        Button {
            selectionHandler()
        } label: {
            categoryContentView
        }
        .frame(height: geometryHeight)
        .buttonStyle(PlainButtonStyle())
    }

    private var categoryContentView: some View {
        ZStack {
            categoryBackgroundView
            categoryTitleView
        }
    }

    private var categoryBackgroundView: some View {
        Color(red: 90 / 255, green: 40 / 255, blue: 255 / 255)
            .frame(height: geometryHeight)
            .accessibilityIdentifier("lotteryTickets")
    }

    private var categoryTitleView: some View {
        PSText(category.title)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.ltWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.leading, 30)
    }
}

struct ShopContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ShopCategoryView(category: .lotteryTickets, geometryHeight: 750) {}
    }
}
