//
//  PaymentMethodResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PaymentMethodResponse
struct PaymentMethodResponse: Decodable {
    /// This is the payment type associated with this payment method
    let paymentMethod: PaymentType
    /// This is the currency of the merchant account, e.g., USD or CAD
    let currencyCode: String
    /// Account id
    let accountId: String
    /// Account configuration
    let accountConfiguration: AccountConfigurationResponse?
}
