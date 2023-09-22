//
//  ShopItemDetailQuantityView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopItemDetailQuantityView: View {
    @Binding var selectedQuantity: Int
    let availableQuantity: Int?
    let geometry: GeometryProxy

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            titleView
            quantitiesView
            Divider()
        }
        .frame(height: geometry.size.height * (UIDevice.current.hasNotch ? 0.13 : 0.14))
    }

    private var titleView: some View {
        PSText("Quantity")
            .foregroundColor(.ltDarkPurple)
            .font(.system(size: 17, weight: .semibold))
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
    }

    private var quantitiesView: some View {
        Group {
            if let availableQuantity, availableQuantity > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(1...availableQuantity, id: \.self) { quantity in
                            quantityView(for: quantity)
                        }
                    }
                }
            } else {
                unavailableQuantityView
            }
        }
    }

    private func quantityView(for quantity: Int) -> some View {
        VStack {
            quantityTitleView(for: quantity)
            Spacer()
            selectedQuantityView(for: quantity)
        }
    }

    private func quantityTitleView(for quantity: Int) -> some View {
        Text(String(quantity))
            .font(.system(size: 17, weight: selectedQuantity == quantity ? .semibold : .regular))
            .frame(width: geometry.size.width * 0.17)
            .foregroundColor(selectedQuantity == quantity ? .ltDarkPurple : .ltDarkPurple.opacity(0.6))
            .onTapGesture { selectedQuantity = quantity }
            .accessibilityIdentifier("quantityView\(quantity)")
    }

    private func selectedQuantityView(for quantity: Int) -> some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.1, height: 5)
            .foregroundColor(.ltDarkPurple)
            .opacity(selectedQuantity == quantity ? 1 : 0)
    }

    private var unavailableQuantityView: some View {
        PSText("No quantity available")
            .foregroundColor(.ltDarkPurple.opacity(0.6))
            .font(.system(size: 17, weight: .regular))
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
    }
}

struct ShopItemDetailQuantityView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            StatefulPreviewWrapper(1) {
                ShopItemDetailQuantityView(
                    selectedQuantity: $0,
                    availableQuantity: 0,
                    geometry: geometry
                )
            }
        }
    }
}
