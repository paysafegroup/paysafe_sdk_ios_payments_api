//
//  PaymentMethod.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//


/// PaymentMethod
public struct PaymentMethod {
    /// This is the payment type associated with this payment method
    public let paymentMethod: PaymentType
    /// This is the currency of the merchant account, e.g., USD or CAD
    let currencyCode: String
    /// Account id
    let accountId: String
    /// Account configuration
    public let accountConfiguration: AccountConfiguration?
}

extension PaymentMethodResponse {
    func toPaymentMethod() -> PaymentMethod {
        PaymentMethod(
            paymentMethod: paymentMethod,
            currencyCode: currencyCode,
            accountId: accountId,
            accountConfiguration: accountConfiguration.map { configuration in
                AccountConfiguration(
                    id: configuration.id,
                    isApplePay: configuration.isApplePay,
                    cardTypeConfig: configuration.cardTypeConfig,
                    clientId: configuration.clientId
                )
            }
        )
    }
}
