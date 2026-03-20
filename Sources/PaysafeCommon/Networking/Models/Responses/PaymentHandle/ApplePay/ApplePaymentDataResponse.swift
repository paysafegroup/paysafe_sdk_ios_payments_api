//
//  ApplePaymentDataResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ApplePaymentDataResponse
struct ApplePaymentDataResponse: Decodable {
    /// Apple Pay token header
    let header: ApplePaymentHeaderResponse
}
