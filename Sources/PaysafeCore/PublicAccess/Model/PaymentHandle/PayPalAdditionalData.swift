//
//  PayPalAdditionalData.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PayPalAdditionalData
public struct PayPalAdditionalData: Encodable {
    /// Consumer id
    let consumerId: String
    /// Recipient description
    let recipientDescription: String?
    /// Language
    let language: Language?
    /// Shipping preference
    let shippingPreference: ShippingPreference?
    /// Consumer message
    let consumerMessage: String?
    /// Order description
    let orderDescription: String?
    /// Recipient type
    let recipientType: RecipientType?

    /// Public initializer required in order to be used in a different module.
    public init(
        consumerId: String,
        recipientDescription: String?,
        language: Language?,
        shippingPreference: ShippingPreference?,
        consumerMessage: String?,
        orderDescription: String?,
        recipientType: RecipientType? = .payPalId
    ) {
        self.consumerId = consumerId
        self.recipientDescription = recipientDescription
        self.language = language
        self.shippingPreference = shippingPreference
        self.consumerMessage = consumerMessage
        self.orderDescription = orderDescription
        self.recipientType = recipientType
    }

    /// PayPalRequest
    var request: PayPalRequest {
        PayPalRequest(
            consumerId: consumerId,
            recipientDescription: recipientDescription,
            language: language?.request,
            shippingPreference: shippingPreference?.request,
            consumerMessage: consumerMessage,
            orderDescription: orderDescription,
            recipientType: recipientType?.request
        )
    }
}
