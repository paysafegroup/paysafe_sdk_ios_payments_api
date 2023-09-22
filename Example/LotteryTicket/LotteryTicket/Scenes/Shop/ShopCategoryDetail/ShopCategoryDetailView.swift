//
//  ShopCategoryDetailView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct ShopCategoryDetailView<ViewModel: ShopCategoryDetailViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(category: ShopCategory) {
        viewModel = ViewModel(category: category)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)], spacing: 2) {
                    ForEach($viewModel.items, id: \.id) { item in
                        ShopItemCardView(
                            item: item.wrappedValue,
                            geometryHeight: geometry.size.height * 0.44,
                            selectionHandler: {
                                viewModel.select(item: item.wrappedValue)
                            }, favouriteHandler: {
                                viewModel.toggleFavourite(for: item)
                            }
                        )
                    }
                }
            }
            .navigationTitle(viewModel.category.title)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("arrowBack")
                    }
                }
            }
            .navigationBarItems(trailing: trailingNavigationView)
            .onAppear(perform: viewModel.onAppear)
        }
        .fullScreenCover(item: $viewModel.selectedItem) { _ in
            ShopItemDetailView(item: $viewModel.selectedItem)
        }
    }

    private var trailingNavigationView: some View {
        Button {} label: {
            Image("magnifyingGlass")
                .imageScale(.large)
                .foregroundColor(.ltDarkPurple)
        }
    }
}

struct ShopCategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShopCategoryDetailView(category: .lotteryTickets)
    }
}
