//
//  PSText.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct PSText: View {
    let text: String?
    let defaultText: String

    init(
        _ text: String?,
        defaultText: String = ""
    ) {
        self.text = text
        self.defaultText = defaultText
    }

    var body: some View {
        Text(text ?? defaultText)
    }
}
