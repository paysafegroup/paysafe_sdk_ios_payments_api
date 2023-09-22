//
//  PaymentResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore

extension PaymentResponse {
    static func jsonMock(paymentHandleId: String) -> String {
        """
        {
            "id": "\(paymentHandleId)",
            "paymentType": "CARD",
            "paymentHandleToken": "token-123",
            "merchantRefNum": "ref-123",
            "currencyCode": "USD",
            "txnTime": "2022-04-01T12:00:00Z",
            "status": "success",
            "amount": 100.0,
            "usage": "single-use",
            "timeToLiveSeconds": 300,
            "transactionType": "PAYMENT",
            "card": {
                "cardExpiry": {
                    "month": "10",
                    "year": "2028"
                },
                "holderName": "John Doe",
                "cardBin": "400000",
                "lastDigits": "1091"
            },
            "returnLinks": [
                {
                    "rel": "default",
                    "href": "https://usgaminggamblig.com/payment/return/",
                    "method": "GET"
                },
                {
                    "rel": "on_completed",
                    "href": "https://usgaminggamblig.com/payment/return/success",
                    "method": "GET"
                },
                {
                    "rel": "on_failed",
                    "href": "https://usgaminggamblig.com/payment/return/failed",
                    "method": "GET"
                }
            ],
            "accountId": "139203223"
        }
        """
    }

    static func jsonMockWith3DS(
        paymentHandleId: String,
        networkToken: NetworkToken? = nil
    ) -> String {
        var networkTokenString = ""
        if let token = networkToken {
            networkTokenString = """
                ,"networkToken" : {
                  "bin": "\(token.bin)"
                }
            """
        }

        return """
        {
            "id": "\(paymentHandleId)",
            "paymentType": "CARD",
            "paymentHandleToken": "token-123",
            "merchantRefNum": "ref-123",
            "currencyCode": "USD",
            "txnTime": "2022-04-01T12:00:00Z",
            "status": "success",
            "amount": 100.0,
            "usage": "single-use",
            "timeToLiveSeconds": 300,
            "transactionType": "PAYMENT",
            "card": {
                "cardBin": "400000"\(networkTokenString)
            },
            "returnLinks": [
                {
                    "rel": "default",
                    "href": "https://usgaminggamblig.com/payment/return/",
                    "method": "GET"
                },
                {
                    "rel": "on_completed",
                    "href": "https://usgaminggamblig.com/payment/return/success",
                    "method": "GET"
                },
                {
                    "rel": "on_failed",
                    "href": "https://usgaminggamblig.com/payment/return/failed",
                    "method": "GET"
                }
            ],
            "threeDs": {
                "merchantUrl": "https://example.com/merchant",
                "deviceChannel": "SDK",
                "messageCategory": "PAYMENT_TRANSACTION",
                "authenticationPurpose": "PAYMENT_TRANSACTION"
            },
            "accountId": "139203223"
        }
        """
    }
}
