//
//  PaymentAccountDetailsResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentAccountDetailsResponse
struct PaymentAccountDetailsResponse: Decodable {
    /// Created date
    let createdDate: String?
    /// Created range
    let createdRange: CreatedRangeResponse?
}
