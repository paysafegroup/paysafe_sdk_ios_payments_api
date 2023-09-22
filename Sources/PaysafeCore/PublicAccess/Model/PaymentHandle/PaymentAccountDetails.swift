//
//  PaymentAccountDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//
//

/// PaymentAccountDetails
public struct PaymentAccountDetails: Encodable {
    /// Created date
    let createdDate: String?
    /// Created range
    let createdRange: CreatedRange?

    /// - Parameters:
    ///   - createdDate: Created date
    ///   - createdRange: Created range
    public init(
        createdDate: String?,
        createdRange: CreatedRange?
    ) {
        self.createdDate = createdDate
        self.createdRange = createdRange
    }

    /// PaymentAccountDetailsRequest
    var request: PaymentAccountDetailsRequest {
        PaymentAccountDetailsRequest(
            createdDate: createdDate,
            createdRange: createdRange?.request
        )
    }
}
