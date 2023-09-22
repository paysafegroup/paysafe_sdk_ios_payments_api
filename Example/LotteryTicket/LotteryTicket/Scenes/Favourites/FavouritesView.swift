//
//  FavouritesView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct FavouritesView<ViewModel: FavouritesViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var tabSelection: TabItem

    init(tabSelection: Binding<TabItem>) {
        viewModel = ViewModel()
        _tabSelection = tabSelection
    }

    var body: some View {
        NavigationView {
            PSText("")
                .navigationTitle("Favourites")
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(.favourites) { FavouritesView(tabSelection: $0) }
    }
}
