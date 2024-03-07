//
//  PSPayPal.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation
#if canImport(PaysafeCommon)
import CorePayments
import PayPalNativePayments
import PayPalWebPayments
import PaysafeCommon
#else
import PayPal
#endif

/// PSPayPal
public class PSPayPal {
    /// PSPayPalRenderType
    let renderType: PSPayPalRenderType
    /// PayPalNativeCheckoutClient
    var payPalNativeClient: PayPalNativeCheckoutClient?
    /// PayPalWebCheckoutClient
    var payPalWebClient: PayPalWebCheckoutClient?
    /// Initiate PayPal flow subject
    private let initiatePayPalFlowSubject = PassthroughSubject<PSPayPalResult, PSError>()
    /// Client id
    private let clientId: String
    /// Environment
    private let environment: PSPayPalEnvironment

    /// - Parameters:
    ///   - clientId: Client id
    ///   - environment: Paypal environment
    ///   - renderType: PSPayPalRenderType
    public init(
        clientId: String,
        environment: PSPayPalEnvironment,
        renderType: PSPayPalRenderType
    ) {
        self.clientId = clientId
        self.environment = environment
        self.renderType = renderType
    }

    /// Method used to initiate the PayPal flow based on render type.
    ///
    /// - Parameters:
    ///   - orderId: PayPal order id
    public func initiatePayPalFlow(
        orderId: String
    ) -> AnyPublisher<PSPayPalResult, PSError> {
        let config = CoreConfig(
            clientID: clientId,
            environment: environment.toCoreEnvironment
        )
        switch renderType {
        case .native:
            payPalNativeClient = PayPalNativeCheckoutClient(config: config)
            payPalNativeClient?.delegate = self
            initiatePayPalNativeCheckout(using: orderId)
        case .web:
            payPalWebClient = PayPalWebCheckoutClient(config: config)
            payPalWebClient?.delegate = self
            initiatePayPalWebCheckout(using: orderId)
        }
        return initiatePayPalFlowSubject.eraseToAnyPublisher()
    }
}

// MARK: - Private
private extension PSPayPal {
    /// Initiates PayPal native checkout.
    ///
    /// - Parameters:
    ///   - orderId: PayPal order id
    func initiatePayPalNativeCheckout(using orderId: String) {
        // Skip initiate PayPal native checkout in unit test
        guard NSClassFromString("XCTest") == nil else { return }
        Task { [weak self] in
            guard let self else { return }
            let request = PayPalNativeCheckoutRequest(orderID: orderId)
            await payPalNativeClient?.start(request: request)
        }
    }

    /// Initiates PayPal web checkout.
    func initiatePayPalWebCheckout(using orderId: String) {
        // Skip initiate PayPal web checkout in unit test
        guard NSClassFromString("XCTest") == nil else { return }
        DispatchQueue.main.async {
            let request = PayPalWebCheckoutRequest(orderID: orderId)
            self.payPalWebClient?.start(request: request)
        }
    }

    /// Finalize the PayPal payment.
    ///
    /// - Parameters:
    ///   - result: PSPayPalResult
    func finalizePayment(_ result: PSPayPalResult) {
        initiatePayPalFlowSubject.send(result)
        switch renderType {
        case .native:
            payPalNativeClient = nil
        case .web:
            payPalWebClient = nil
        }
    }
}

// MARK: - PayPalNativeCheckoutDelegate
extension PSPayPal: PayPalNativeCheckoutDelegate {
    public func paypal(
        _ payPalClient: PayPalNativeCheckoutClient,
        didFinishWithResult result: PayPalNativeCheckoutResult
    ) {
        print("[PayPalNativeCheckoutDelegate] Complete with orderId: \(result.orderID)]")
        finalizePayment(.success)
    }

    public func paypal(
        _ payPalClient: PayPalNativeCheckoutClient,
        didFinishWithError error: CoreSDKError
    ) {
        print("[PayPalNativeCheckoutDelegate] Finish with error: \(error.localizedDescription)]")
        finalizePayment(.failed)
    }

    public func paypalDidCancel(_ payPalClient: PayPalNativeCheckoutClient) {
        print("[PayPalNativeCheckoutDelegate] Did cancel")
        finalizePayment(.cancelled)
    }

    public func paypalWillStart(_ payPalClient: PayPalNativeCheckoutClient) {
        print("[PayPalNativeCheckoutDelegate] Paypal will start]")
    }
}

// MARK: - PayPalWebCheckoutDelegate
extension PSPayPal: PayPalWebCheckoutDelegate {
    public func payPal(
        _ payPalClient: PayPalWebCheckoutClient,
        didFinishWithResult result: PayPalWebCheckoutResult
    ) {
        print("[PayPalWebCheckoutDelegate] Complete with orderId: \(result.orderID)]")
        finalizePayment(.success)
    }

    public func payPal(
        _ payPalClient: PayPalWebCheckoutClient,
        didFinishWithError error: CoreSDKError
    ) {
        print("[PayPalWebCheckoutDelegate] Finish with error: \(error.localizedDescription)]")
        finalizePayment(.failed)
    }

    public func payPalDidCancel(_ payPalClient: PayPalWebCheckoutClient) {
        print("[PayPalWebCheckoutDelegate] Did cancel")
        finalizePayment(.cancelled)
    }
}
