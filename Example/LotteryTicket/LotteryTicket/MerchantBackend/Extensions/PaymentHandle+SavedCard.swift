//
//  PaymentHandle+SavedCard.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

extension PaymentHandle {
    func toSavedCard(_ singleUseCustomerToken: String) -> SavedCard {
        SavedCard(
            cardBrand: card?.cardType?.toPSCardBrand() ?? .unknown,
            lastDigits: card?.lastDigits ?? "",
            holderName: card?.holderName ?? "",
            expiryMonth: Int(card?.cardExpiry?.month ?? "0") ?? 0,
            expiryYear: Int(card?.cardExpiry?.year ?? "0") ?? 0,
            singleUseCustomerToken: singleUseCustomerToken,
            paymentTokenFrom: paymentHandleToken ?? ""
        )
    }
}
