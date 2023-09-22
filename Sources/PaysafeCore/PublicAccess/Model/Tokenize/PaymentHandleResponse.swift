//
//  PaymentHandleResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentHandleResponse
public struct PaymentHandleResponse {
    /// Account id
    public let accountId: String?
    /// Merchant reference number
    public let merchantRefNum: String
    /// Payment handle token
    public let paymentHandleToken: String
}

extension PaymentHandle {
    func toPaymentHandleResponse() -> PaymentHandleResponse {
        PaymentHandleResponse(
            accountId: accountId,
            merchantRefNum: merchantRefNum,
            paymentHandleToken: paymentHandleToken
        )
    }
}
