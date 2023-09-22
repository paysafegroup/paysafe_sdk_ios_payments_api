//
//  PaymentHandleTokenStatus.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Payment handle status
enum PaymentHandleTokenStatus: String, Decodable {
    /// On creation
    case initiated = "INITIATED"
    /// On successful authentication. You can make Payment Request only if Payment Handle is Payable.
    case payable = "PAYABLE"
    /// On failed authentication
    case failed = "FAILED"
    /// After 299 seconds from INITIATED
    case expired = "EXPIRED"
    /// The Payment Handle was authorized by customer, awaiting PSP response.
    case processing = "PROCESSING"
    /// The Payment request was initiated successfully using the Payment Handle.
    case completed = "COMPLETED"
}
