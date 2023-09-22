//
//  OrderConfirmationViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

final class OrderConfirmationViewModel: ObservableObject {
    private(set) var orderConfirmationDetails: OrderConfirmationDetails

    init(orderConfirmationDetails: OrderConfirmationDetails) {
        self.orderConfirmationDetails = orderConfirmationDetails
    }
}
