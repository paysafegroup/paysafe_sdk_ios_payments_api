//
//  PaymentMethodsResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore

extension PaymentMethodsResponse {
    static func jsonMock() -> String {
        """
        {
            "paymentMethods": [
                {
                    "paymentMethod": "CARD",
                    "currencyCode": "USD",
                    "accountId": "acc123"
                },
                {
                    "paymentMethod": "PAYPAL",
                    "currencyCode": "EUR",
                    "accountId": "acc456"
                }
            ]
        }
        """
    }
}
