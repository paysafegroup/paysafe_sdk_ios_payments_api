//
//  HomeView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct HomeView<ViewModel: HomeViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var tabSelection: TabItem

    init(tabSelection: Binding<TabItem>) {
        viewModel = ViewModel()
        _tabSelection = tabSelection
    }

    var body: some View {
        NavigationView {
            PSText("")
                .navigationTitle("Home")
        }
        .accentColor(.ltDarkPurple)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(.home) { HomeView(tabSelection: $0) }
    }
}
