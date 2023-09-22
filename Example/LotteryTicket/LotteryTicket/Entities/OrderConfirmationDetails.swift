//
//  OrderConfirmationDetails.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

struct OrderConfirmationDetails: Identifiable {
    /// Order id
    let id: String
    /// Account id
    let accountId: String
    /// Merchant reference number
    let merchantRefNum: String
    /// Payment handle token
    let paymentHandleToken: String

    init(
        accountId: String,
        merchantRefNum: String,
        paymentHandleToken: String
    ) {
        id = UUID().uuidString
        self.accountId = accountId
        self.merchantRefNum = merchantRefNum
        self.paymentHandleToken = paymentHandleToken
    }
}
