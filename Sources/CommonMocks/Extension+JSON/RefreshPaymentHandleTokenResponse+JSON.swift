//
//  RefreshPaymentHandleTokenResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon

extension RefreshPaymentHandleTokenResponse {
    public static func jsonMock(status: PaymentHandleTokenStatus) -> String {
        """
        {
            "status": "\(status.rawValue)",
            "paymentHandleToken": "paymentHandleToken"
        }
        """
    }
}
