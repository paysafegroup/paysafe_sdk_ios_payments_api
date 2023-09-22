//
//  PSPayPalLinks.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSPayPalLinks
public struct PSPayPalLinks {
    /// Redirect PayPal url
    let redirectUrl: String
    /// Success PayPal url
    let successUrl: String
    /// Failed PayPal url
    let failedUrl: String
    /// Cancelled PayPal url
    let cancelledUrl: String
    /// Default PayPal url
    let defaultUrl: String

    /// - Parameters:
    ///   - redirectUrl: Redirect PayPal url
    ///   - successUrl: Success PayPal url
    ///   - failedUrl: Failed PayPal url
    ///   - cancelledUrl: Cancelled PayPal url
    ///   - defaultUrl: Default PayPal url
    public init(
        redirectUrl: String,
        successUrl: String,
        failedUrl: String,
        cancelledUrl: String,
        defaultUrl: String
    ) {
        self.redirectUrl = redirectUrl
        self.successUrl = successUrl
        self.failedUrl = failedUrl
        self.cancelledUrl = cancelledUrl
        self.defaultUrl = defaultUrl
    }
}
