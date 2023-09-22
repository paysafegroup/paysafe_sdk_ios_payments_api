//
//  OptionsView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct OptionsView<ViewModel: OptionsViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var tabSelection: TabItem

    init(tabSelection: Binding<TabItem>) {
        viewModel = ViewModel()
        _tabSelection = tabSelection
    }

    var body: some View {
        NavigationView {
            PSText("")
                .navigationTitle("Options")
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(.options) { OptionsView(tabSelection: $0) }
    }
}
