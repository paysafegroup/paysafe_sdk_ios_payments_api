//
//  PaymentResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore

extension PaymentResponse {
    public static func jsonMock(paymentHandleId: String) -> String {
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

    public static func jsonMockWith3DS(
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
    
    public static func jsonMockWithVenmo(paymentHandleToken: String, status: String = "INITIATED") -> String {
        """
        {
            "id": "be39a5e7-29c3-4e37-b96a-673e85a0bc05",
            "paymentType": "VENMO",
            "paymentHandleToken": "\(paymentHandleToken)",
            "merchantRefNum": "a1fbaadf-d93c-4d71-ab5a-75a78d2e2391135",
            "currencyCode": "USD",
            "txnTime": "2024-06-13T14:09:41Z",
            "billingDetails": {
                "street": "100 Queen",
                "street2": "Unit 201",
                "city": "Toronto",
                "zip": "M5H 2N2",
                "country": "US"
            },
            "customerIp": "172.0.0.1",
            "status": "\(status)",
            "links": [
                {
                    "rel": "redirect_payment",
                    "href": "https://api.test.paysafe.com/alternatepayments/v1/redirect?accountId=1002727680&paymentHandleId=be39a5e7-29c3-4e37-b96a-673e85a0bc05&token=eyJhbGciOiJIUzI1NiJ9.eyJhY2QiOiIxMDAyNzI3NjgwIiwicHlkIjoiYmUzOWE1ZTctMjljMy00ZTM3LWI5NmEtNjczZTg1YTBiYzA1IiwiZXhwIjoxNzE4Mjg5NTgxfQ.OzxTH7pRXz1YS2vf-UA2qWhd1YoD8Rs6McKXKaaisUI"
                }
            ],
            "liveMode": false,
            "usage": "SINGLE_USE",
            "action": "REDIRECT",
            "executionMode": "SYNCHRONOUS",
            "amount": 500,
            "merchantDescriptor": {
                "dynamicDescriptor": "OnlineStore",
                "phone": "12345678"
            },
            "timeToLiveSeconds": 899,
            "gatewayResponse": {
                "clientToken": "client-token",
                "sessionToken": "session-token",
                "processor": "BRAINTREE"
            },
            "returnLinks": [
                {
                    "rel": "default",
                    "href": "https://usgaminggamblig.com/payment/return/success"
                },
                {
                    "rel": "on_failed",
                    "href": "https://usgaminggamblig.com/payment/return/failed"
                },
                {
                    "rel": "on_cancelled",
                    "href": "https://usgaminggamblig.com/payment/return/cancelled"
                }
            ],
            "transactionType": "PAYMENT",
            "updatedTime": "2024-06-13T14:09:41Z",
            "statusTime": "2024-06-13T14:09:41Z",
            "profile": {
                "firstName": "John",
                "lastName": "Doe",
                "email": "john.doe@paysafe.com"
            },
            "venmo": {
                "consumerId": "a@b.com"
            }
        }
        """
    }
    
    public static func jsonMockWithVenmo_noGatewayResponse(paymentHandleToken: String, status: String = "INITIATED") -> String {
        """
        {
            "id": "be39a5e7-29c3-4e37-b96a-673e85a0bc05",
            "paymentType": "VENMO",
            "paymentHandleToken": "\(paymentHandleToken)",
            "merchantRefNum": "a1fbaadf-d93c-4d71-ab5a-75a78d2e2391135",
            "currencyCode": "USD",
            "txnTime": "2024-06-13T14:09:41Z",
            "billingDetails": {
                "street": "100 Queen",
                "street2": "Unit 201",
                "city": "Toronto",
                "zip": "M5H 2N2",
                "country": "US"
            },
            "customerIp": "172.0.0.1",
            "status": "\(status)",
            "links": [
                {
                    "rel": "redirect_payment",
                    "href": "https://api.test.paysafe.com/alternatepayments/v1/redirect?accountId=1002727680&paymentHandleId=be39a5e7-29c3-4e37-b96a-673e85a0bc05&token=eyJhbGciOiJIUzI1NiJ9.eyJhY2QiOiIxMDAyNzI3NjgwIiwicHlkIjoiYmUzOWE1ZTctMjljMy00ZTM3LWI5NmEtNjczZTg1YTBiYzA1IiwiZXhwIjoxNzE4Mjg5NTgxfQ.OzxTH7pRXz1YS2vf-UA2qWhd1YoD8Rs6McKXKaaisUI"
                }
            ],
            "liveMode": false,
            "usage": "SINGLE_USE",
            "action": "REDIRECT",
            "executionMode": "SYNCHRONOUS",
            "amount": 500,
            "merchantDescriptor": {
                "dynamicDescriptor": "OnlineStore",
                "phone": "12345678"
            },
            "timeToLiveSeconds": 899,
            "gatewayResponse": {
                "processor": "BRAINTREE"
            },
            "returnLinks": [
                {
                    "rel": "default",
                    "href": "https://usgaminggamblig.com/payment/return/success"
                },
                {
                    "rel": "on_failed",
                    "href": "https://usgaminggamblig.com/payment/return/failed"
                },
                {
                    "rel": "on_cancelled",
                    "href": "https://usgaminggamblig.com/payment/return/cancelled"
                }
            ],
            "transactionType": "PAYMENT",
            "updatedTime": "2024-06-13T14:09:41Z",
            "statusTime": "2024-06-13T14:09:41Z",
            "profile": {
                "firstName": "John",
                "lastName": "Doe",
                "email": "john.doe@paysafe.com"
            },
            "venmo": {
                "consumerId": "a@b.com"
            }
        }
        """
    }
}
