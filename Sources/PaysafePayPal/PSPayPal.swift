//
//  PSPayPal.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import CorePayments
import PayPalNativePayments
import PaysafeCommon
import SafariServices

/// PSPayPal
public class PSPayPal: NSObject {
    /// PSPayPalRenderType
    let renderType: PSPayPalRenderType
    /// PayPalNativeCheckoutClient
    var payPalClient: PayPalNativeCheckoutClient?
    /// SFSafariViewController
    var safariViewController: SFSafariViewController?
    /// PayPal links
    var payPalLinks: PSPayPalLinks?
    /// Initiate PayPal flow subject
    private let initiatePayPalFlowSubject = PassthroughSubject<PSPayPalResult, PSError>()

    /// - Parameters:
    ///   - renderType: PSPayPalRenderType
    public init(
        renderType: PSPayPalRenderType
    ) {
        self.renderType = renderType
    }

    /// Method used to initiate the PayPal flow based on render type.
    ///
    /// - Parameters:
    ///   - orderId: PayPal order id
    ///   - payPalLinks: PayPal links
    public func initiatePayPalFlow(
        orderId: String,
        payPalLinks: PSPayPalLinks
    ) -> AnyPublisher<PSPayPalResult, PSError> {
        switch renderType {
        case let .native(clientId, environment):
            payPalClient = PayPalNativeCheckoutClient(
                config: CoreConfig(
                    clientID: clientId,
                    environment: environment.toCoreEnvironment
                )
            )
            payPalClient?.delegate = self
            initiatePayPalNativeCheckout(using: orderId)
        case .web:
            guard let redirectUrl = URL(string: payPalLinks.redirectUrl) else {
                return Fail(error: .genericAPIError()).eraseToAnyPublisher()
            }
            safariViewController = SFSafariViewController(url: redirectUrl)
            safariViewController?.modalPresentationStyle = .formSheet
            safariViewController?.dismissButtonStyle = .close
            safariViewController?.delegate = self
            self.payPalLinks = payPalLinks
            initiatePayPalWebCheckout()
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
            await payPalClient?.start(request: request)
        }
    }

    /// Initiates PayPal web checkout.
    func initiatePayPalWebCheckout() {
        // Skip initiate PayPal web checkout in unit test
        guard let safariViewController, NSClassFromString("XCTest") == nil else { return }
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            var presentingViewController = window?.rootViewController
            while let presented = presentingViewController?.presentedViewController {
                presentingViewController = presented
            }
            presentingViewController?.present(safariViewController, animated: true)
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
            payPalClient = nil
        case .web:
            safariViewController = nil
        }
    }
}

// MARK: - PayPalNativeCheckoutDelegate
extension PSPayPal: PayPalNativeCheckoutDelegate {
    public func paypal(
        _ payPalClient: PayPalNativePayments.PayPalNativeCheckoutClient,
        didFinishWithResult result: PayPalNativePayments.PayPalNativeCheckoutResult
    ) {
        print("[PSPayPalDelegate] Complete with orderId: \(result.orderID)]")
        finalizePayment(.success)
    }

    public func paypal(
        _ payPalClient: PayPalNativePayments.PayPalNativeCheckoutClient,
        didFinishWithError error: CorePayments.CoreSDKError
    ) {
        print("[PSPayPalDelegate] Finish with error: \(error.localizedDescription)]")
        finalizePayment(.failed)
    }

    public func paypalDidCancel(_ payPalClient: PayPalNativePayments.PayPalNativeCheckoutClient) {
        print("[PSPayPalDelegate] Did cancel")
        finalizePayment(.cancelled)
    }

    public func paypalWillStart(_ payPalClient: PayPalNativePayments.PayPalNativeCheckoutClient) {
        print("[PSPayPalDelegate] Paypal will start]")
    }
}

// MARK: - SFSafariViewControllerDelegate
extension PSPayPal: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) { [weak self] in
            self?.finalizePayment(.cancelled)
        }
    }

    public func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        guard let payPalLinks else { return }
        switch URL.absoluteString {
        case payPalLinks.successUrl:
            controller.dismiss(animated: true) { [weak self] in
                self?.finalizePayment(.success)
            }
        case payPalLinks.failedUrl, payPalLinks.defaultUrl:
            controller.dismiss(animated: true) { [weak self] in
                self?.finalizePayment(.failed)
            }
        case payPalLinks.cancelledUrl:
            controller.dismiss(animated: true) { [weak self] in
                self?.finalizePayment(.cancelled)
            }
        default:
            break
        }
    }
}
