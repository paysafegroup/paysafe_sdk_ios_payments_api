//
//  FinalizeResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments

extension FinalizeResponse {
    public static func jsonMock() -> String {
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
                "cardBin": "4000000"
            },
            "merchantUrl": "merch-ref",
            "cavv": "cavv",
            "threeDSecureVersion": "1.0.0",
            "currency": "USD",
            "status": "COMPLETED"
        }
        """
    }

    public static func jsonMock(with networkToken: NetworkToken) -> String {
        let networkTokenString = """
            ,"networkToken" : {
              "bin": "\(networkToken.bin)"
            }
        """

        return """
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
                "cardBin": "4000000"\(networkTokenString)
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
