//
//  PaymentMethodsResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentMethodsResponse
struct PaymentMethodsResponse: Decodable {
    /// Payment methods
    let paymentMethods: [PaymentMethodResponse]
}
