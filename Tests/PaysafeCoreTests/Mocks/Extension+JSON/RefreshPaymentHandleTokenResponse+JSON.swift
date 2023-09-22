//
//  RefreshPaymentHandleTokenResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore

extension RefreshPaymentHandleTokenResponse {
    static func jsonMock(status: PaymentHandleTokenStatus) -> String {
        """
        {
            "status": "\(status.rawValue)",
            "paymentHandleToken": "paymentHandleToken"
        }
        """
    }
}
