//
//  MainView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct MainView: View {
    @State var selectedTab: TabItem

    var body: some View {
        VStack(spacing: 0) {
            tabBarContentView
            tabBarDividerView
            tabBarItemsView
            tabBarSpacerView
        }
    }

    private var tabBarContentView: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView(tabSelection: $selectedTab)
            case .shop:
                ShopView(tabSelection: $selectedTab)
            case .cart:
                CartView(tabSelection: $selectedTab)
            case .favourites:
                FavouritesView(tabSelection: $selectedTab)
            case .options:
                OptionsView(tabSelection: $selectedTab)
            }
        }
    }

    private var tabBarDividerView: some View {
        Divider()
            .padding(.bottom, UIDevice.current.hasNotch ? 12 : 8)
    }

    private var tabBarItemsView: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 0) {
                        Image(tab.iconName)
                            .renderingMode(.template)
                            .foregroundColor(selectedTab == tab ? .ltPurple : .ltDarkPurple)
                            .frame(width: 40, height: 40)

                        Ellipse()
                            .foregroundColor(.ltPurple)
                            .frame(width: 6, height: 6)
                            .opacity(selectedTab == tab ? 1 : 0)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            }
        }
    }

    private var tabBarSpacerView: some View {
        Spacer(minLength: UIDevice.current.hasNotch ? 0 : 10)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(selectedTab: .shop)
    }
}
