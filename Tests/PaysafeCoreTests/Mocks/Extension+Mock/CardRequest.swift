//
//  CardRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore

extension CardRequest {
    static func mock() -> CardRequest {
        CardRequest(
            cardNum: "4000000000001091",
            cardExpiry: CardExpiryRequest(
                month: 10,
                year: 28
            ),
            cvv: "111",
            holderName: "John Doe",
            cardType: nil,
            nickName: nil
        )
    }

    static func mockSavedCard() -> CardRequest {
        CardRequest(
            cvv: "123",
            holderName: "John Doe"
        )
    }
}
