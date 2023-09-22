//
//  PKPayment+Extensions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit

extension PKPayment {
    func toApplePayPaymentToken() -> ApplePayPaymentToken {
        let paymentData = try? JSONDecoder().decode(ApplePaymentData.self, from: token.paymentData)
        return ApplePayPaymentToken(
            token: ApplePayToken(
                paymentData: paymentData,
                paymentMethod: ApplePaymentMethod(
                    displayName: token.paymentMethod.displayName,
                    network: token.paymentMethod.network?.rawValue,
                    type: token.paymentMethod.type.toString()
                ),
                transactionIdentifier: token.transactionIdentifier
            )
        )
    }
}
