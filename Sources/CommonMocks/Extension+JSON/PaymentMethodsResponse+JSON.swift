//
//  PaymentMethodsResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon

extension PaymentMethodsResponse {
    public static func jsonMock() -> String {
        """
        {
            "paymentMethods": [
                {
                    "paymentMethod": "CARD",
                    "currencyCode": "USD",
                    "accountId": "acc123"
                },
                {
                    "paymentMethod": "VENMO",
                    "currencyCode": "EUR",
                    "accountId": "acc456"
                }
            ]
        }
        """
    }
    public static func jsonMockWithVenmo() -> String {
        """
        {
            "paymentMethods": [
                {
                    "paymentMethod": "CARD",
                    "currencyCode": "USD",
                    "accountId": "acc123"
                },
                {
                    "paymentMethod": "VENMO",
                    "currencyCode": "EUR",
                    "accountId": "acc456"
                },
                {
                    "paymentMethod": "VENMO",
                    "currencyCode": "USD",
                    "accountId": "acc789"
                }
            ]
        }
        """
    }
    
    public static func jsonMockBadRequest() -> String {
        """
        {
            "error": {
                "code": "5068",
                "message": "Field error(s)",
                "details": [
                    "Either you submitted a request that is missing a mandatory field or the value of a field does not match the format expected."
                ],
                "fieldErrors": [
                    {
                        "field": "currencyCode",
                        "error": "Value is required."
                    }
                ]
            }
        }
        """
    }
}
