//
//  FinalizeResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore

extension FinalizeResponse {
    static func jsonMock() -> String {
        """
        {
            "id": "test_id1234",
            "deviceFingerprintingId": "fpId",
            "merchantRefNum": "test1234MerchRefNum",
            "threeDResult": "Y",
            "txnTime": "txnTime",
            "directoryServerTransactionId": "testDirectoryServerTransactionId",
            "amount": 100.00,
            "eci": 3.0,
            "acsUrl": "acsURL",
            "card": {
                "cardExpiry": {
                    "month": "10",
                    "year": "2025"
                },
                "holderName": "john doe",
                "cardBin": "4000000",
                "lastDigits": "1091"
            },
            "merchantUrl": "merch-ref",
            "cavv": "cavv",
            "threeDSecureVersion": "1.0.0",
            "currency": "USD",
            "status": "COMPLETED"
        }
        """
    }
}
