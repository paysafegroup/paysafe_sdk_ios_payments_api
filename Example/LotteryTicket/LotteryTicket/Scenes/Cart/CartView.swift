//
//  CartView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CartView<ViewModel: CartViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var tabSelection: TabItem

    init(tabSelection: Binding<TabItem>) {
        viewModel = ViewModel()
        _tabSelection = tabSelection
    }

    var body: some View {
        NavigationView {
            PSText("")
                .navigationTitle("Cart")
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(.cart) { CartView(tabSelection: $0) }
    }
}
