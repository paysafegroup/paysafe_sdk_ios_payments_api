//
//  CardRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// CardRequest
struct CardRequest: Encodable {
    /// Card number
    let cardNum: String?
    /// Card expiry
    let cardExpiry: CardExpiryRequest?
    /// CVV
    let cvv: String
    /// Cardholder name
    let holderName: String
    /// Card type
    let cardType: String?
    /// Nickname
    let nickName: String?

    /// - Parameters:
    ///   - cardNum: Card number
    ///   - cardExpiry: Card expiry
    ///   - cvv: CVV
    ///   - holderName: Cardholder name
    ///   - cardType: Card type
    ///   - nickName: Nickname
    init(
        cardNum: String? = nil,
        cardExpiry: CardExpiryRequest? = nil,
        cvv: String,
        holderName: String,
        cardType: String? = nil,
        nickName: String? = nil
    ) {
        self.cardNum = cardNum
        self.cardExpiry = cardExpiry
        self.cvv = cvv
        self.holderName = holderName
        self.cardType = cardType
        self.nickName = nickName
    }
}
