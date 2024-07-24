//
//  PaymentAccountDetailsRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentAccountDetailsRequest
struct PaymentAccountDetailsRequest: Encodable {
    /// Created date
    let createdDate: String?
    /// Created range
    let createdRange: CreatedRangeRequest?
}
