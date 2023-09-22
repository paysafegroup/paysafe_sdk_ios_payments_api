//
//  PSBackgroundView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct PSBackgroundView: View {
    var color: Color

    var body: some View {
        Rectangle()
            .fill(color)
    }
}

struct PSBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        PSBackgroundView(color: .ltGray)
    }
}
