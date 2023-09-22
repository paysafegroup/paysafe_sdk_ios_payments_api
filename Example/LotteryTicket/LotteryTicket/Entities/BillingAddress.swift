//
//  BillingAddress.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation
import PaysafeCore

struct BillingAddress {
    /// Billing address id
    let id: String = UUID().uuidString
    /// Billing address nickname
    let nickName: String
    /// Billing address street
    let street: String
    /// Billing address city
    let city: String
    /// Billing address state
    let state: String
    /// Billing address country
    let country: String
    /// Billing address zip code
    let zip: String

    var billingAddressString: String {
        "\(nickName)\n\(street)\n\(city), \(state), \(zip)"
    }
}

extension BillingAddress {
    func toBillingDetails() -> BillingDetails {
        BillingDetails(
            country: country,
            zip: zip,
            state: state,
            city: city,
            street: street,
            street1: nil,
            street2: nil,
            phone: nil,
            nickName: nickName
        )
    }
}
