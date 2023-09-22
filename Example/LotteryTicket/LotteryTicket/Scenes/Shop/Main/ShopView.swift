//
//  ShopView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopView<ViewModel: ShopViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var tabSelection: TabItem

    init(tabSelection: Binding<TabItem>) {
        viewModel = ViewModel()
        _tabSelection = tabSelection
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 2) {
                        ForEach(viewModel.categories, id: \.rawValue) { category in
                            shopCategoryView(for: category, and: geometry)
                        }
                    }
                }
                .padding([.top, .bottom], 1.0)
                .navigationBarItems(leading: leadingNavigationView, trailing: trailingNavigationView)
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .navigationViewStyle(.stack)
        .accentColor(.ltDarkPurple)
    }

    private func shopCategoryView(for category: ShopCategory, and geometry: GeometryProxy) -> some View {
        NavigationLink(
            destination: shopCategoryDetailView(for: category),
            tag: category,
            selection: $viewModel.selectedCategory
        ) {
            ShopCategoryView(category: category, geometryHeight: geometry.size.height * 0.3) {
                viewModel.select(category: category)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func shopCategoryDetailView(for category: ShopCategory) -> some View {
        NavigationLazyView(ShopCategoryDetailView(category: category))
    }

    private var leadingNavigationView: some View {
        PSText("Shop")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.ltDarkPurple)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var trailingNavigationView: some View {
        HStack(spacing: 10) {
            Button {
                // self.tabSelection = 1
            } label: {
                Image("magnifyingGlass")
                    .imageScale(.large)
                    .foregroundColor(.ltDarkPurple)
            }

            Button {
                // self.tabSelection = 4
            } label: {
                Image("profile")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(.shop) { ShopView(tabSelection: $0) }
    }
}
