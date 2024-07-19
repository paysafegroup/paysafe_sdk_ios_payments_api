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
    
    static func jsonMockWithVenmo(paymentHandleToken: String, status: String = "INITIATED") -> String {
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
                "clientToken": "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJleUowZVhBaU9pSktWMVFpTENKaGJHY2lPaUpGVXpJMU5pSXNJbXRwWkNJNklqSXdNVGd3TkRJMk1UWXRjMkZ1WkdKdmVDSXNJbWx6Y3lJNkltaDBkSEJ6T2k4dllYQnBMbk5oYm1SaWIzZ3VZbkpoYVc1MGNtVmxaMkYwWlhkaGVTNWpiMjBpZlEuZXlKbGVIQWlPakUzTVRnek5UUXpNamdzSW1wMGFTSTZJamd5T0dJek9EVm1MVGsyWmpNdE5HUXhNeTFpWkRNMkxUUTRZVEUyTkRZeFpUVTJPQ0lzSW5OMVlpSTZJalJuZUhodWVITjRiVFV5Y0RaemEzQWlMQ0pwYzNNaU9pSm9kSFJ3Y3pvdkwyRndhUzV6WVc1a1ltOTRMbUp5WVdsdWRISmxaV2RoZEdWM1lYa3VZMjl0SWl3aWJXVnlZMmhoYm5RaU9uc2ljSFZpYkdsalgybGtJam9pTkdkNGVHNTRjM2h0TlRKd05uTnJjQ0lzSW5abGNtbG1lVjlqWVhKa1gySjVYMlJsWm1GMWJIUWlPbVpoYkhObGZTd2ljbWxuYUhSeklqcGJJbTFoYm1GblpWOTJZWFZzZENKZExDSnpZMjl3WlNJNld5SkNjbUZwYm5SeVpXVTZWbUYxYkhRaVhTd2liM0IwYVc5dWN5STZlMzE5LkNIMGRLa0VObXYyeHJ3ZFVXN3BwN3lDTU1EQk1XSENfTEkwNm9xUkVuWDZtS2tSd0tqeTJFYURwRTJTWEFUazl3cTRWenBwS1ZGSWF3ZjdDWVVCX1FRIiwiY29uZmlnVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzRneHhueHN4bTUycDZza3AvY2xpZW50X2FwaS92MS9jb25maWd1cmF0aW9uIiwiZ3JhcGhRTCI6eyJ1cmwiOiJodHRwczovL3BheW1lbnRzLnNhbmRib3guYnJhaW50cmVlLWFwaS5jb20vZ3JhcGhxbCIsImRhdGUiOiIyMDE4LTA1LTA4IiwiZmVhdHVyZXMiOlsidG9rZW5pemVfY3JlZGl0X2NhcmRzIl19LCJjbGllbnRBcGlVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvNGd4eG54c3htNTJwNnNrcC9jbGllbnRfYXBpIiwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwibWVyY2hhbnRJZCI6IjRneHhueHN4bTUycDZza3AiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsInZlbm1vIjoib2ZmIiwiY2hhbGxlbmdlcyI6W10sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL29yaWdpbi1hbmFseXRpY3Mtc2FuZC5zYW5kYm94LmJyYWludHJlZS1hcGkuY29tLzRneHhueHN4bTUycDZza3AifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImJpbGxpbmdBZ3JlZW1lbnRzRW5hYmxlZCI6dHJ1ZSwiZW52aXJvbm1lbnROb05ldHdvcmsiOmZhbHNlLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYWxsb3dIdHRwIjp0cnVlLCJkaXNwbGF5TmFtZSI6IlBheVNhZmUiLCJjbGllbnRJZCI6IkFXOHJnR3J5N0hucEhEUWtDd2FhOHF0RksxTUZnVUlia2EyR3N1Q2VYZExsZlNLOHNmcVFOZnd1M1ZBZ2VDNEFIZl94Y0xtVkhnVnJZdmJ5IiwiYmFzZVVybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXNzZXRzVXJsIjoiaHR0cHM6Ly9jaGVja291dC5wYXlwYWwuY29tIiwiZGlyZWN0QmFzZVVybCI6bnVsbCwiZW52aXJvbm1lbnQiOiJvZmZsaW5lIiwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwibWVyY2hhbnRBY2NvdW50SWQiOiJwYXlzYWZlIiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn19",
                "sessionToken": "eyJhbGciOiJIUzI1NiJ9.eyJwbXRoZGxJZCI6ImU3NTZhZTcyLTU0NGItNGIxOC1hMGY2LTcwYjIzNDQ3MGNlYiIsIm1yY2hudENuc21ySWQiOiJhQGIuY29tIiwiYWNjdElkIjoiMzE0ODFhYmMtMjRhYi00M2U1LWI2MmEtMjk2NTA2MTM3ZmVkIiwiZXhwIjoxNzE4Mjg4NjgxfQ.9jR7PLG_AOKZ6JIaAh5EErGGw7cRvy-kkdg-mcpZ7fQ",
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
    
    static func jsonMockWithVenmo_noGatewayResponse(paymentHandleToken: String, status: String = "INITIATED") -> String {
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
