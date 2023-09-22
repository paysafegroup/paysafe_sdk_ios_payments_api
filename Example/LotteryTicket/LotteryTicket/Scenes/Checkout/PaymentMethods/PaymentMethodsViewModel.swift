//
//  PaymentMethodsViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeApplePay
import PaysafeCore
import SwiftUI

final class PaymentMethodsViewModel: ObservableObject {
    let billingAddress: BillingAddress?
    let item: ShopItem?
    let totalPrice: Double

    @Published var paymentMethods: [PaymentMethod] = []
    @Published var isloading = false
    @Published var presentAlert = false
    @Published var orderConfirmationDetails: OrderConfirmationDetails?

    private(set) var applePayContext: PSApplePayContext?
    private var payPalContext: PSPayPalContext?

    private var alertTexts: (title: String, message: String)?
    var alertTitle: String { alertTexts?.title ?? "" }
    var alertMessage: String { alertTexts?.message ?? "" }

    private var isFirstLaunch = true

    private let dispatchGroup = DispatchGroup()
    private var temporaryPaymentMethods: [(paymentMethod: PaymentMethod, isAvailable: Bool)] = [
        (.creditCard, true),
        (.payPal, false),
        (.applePay, false)
    ]

    init(
        billingAddress: BillingAddress?,
        item: ShopItem?,
        totalPrice: Double
    ) {
        self.billingAddress = billingAddress
        self.item = item
        self.totalPrice = totalPrice
    }

    func onAppear(using paymentManager: PaymentManager) {
        guard isFirstLaunch, !isloading else { return }
        isloading = true
        dispatchGroup.enter()
        PSApplePayContext.initialize(
            currencyCode: "USD",
            accountId: paymentManager.cardAccountId,
            merchantIdentifier: "merchant.com.paysafe.app",
            countryCode: "US"
        ) { [weak self] result in
            asyncMain { [weak self] in
                guard let self else { return }
                switch result {
                case let .success(applePayContext):
                    self.applePayContext = applePayContext
                    if let index = temporaryPaymentMethods.firstIndex(where: { $0.paymentMethod == .applePay }) {
                        temporaryPaymentMethods[index].isAvailable = true
                    }
                case .failure:
                    break
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.enter()
        PSPayPalContext.initialize(
            currencyCode: "USD",
            accountId: paymentManager.paypalAccountId
        ) { [weak self] result in
            asyncMain { [weak self] in
                guard let self else { return }
                switch result {
                case let .success(payPalContext):
                    self.payPalContext = payPalContext
                    if let index = temporaryPaymentMethods.firstIndex(where: { $0.paymentMethod == .payPal }) {
                        temporaryPaymentMethods[index].isAvailable = true
                    }
                case .failure:
                    break
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            isloading = false
            paymentMethods = temporaryPaymentMethods
                .filter(\.isAvailable)
                .map(\.paymentMethod)
        }
        isFirstLaunch = false
    }

    func presentApplePay(using paymentManager: PaymentManager) {
        guard let applePayContext, let item, let billingAddress else { return }
        let completion: PSTokenizeBlock = { [weak self] tokenizeResult in
            asyncMainDelayed(with: 2) { [weak self] in
                guard let self else { return }
                switch tokenizeResult {
                case let .success(paymentHandleToken):
                    orderConfirmationDetails = OrderConfirmationDetails(
                        accountId: paymentManager.cardAccountId,
                        merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
                        paymentHandleToken: paymentHandleToken
                    )
                case let .failure(error):
                    guard error.errorCode != .applePayUserCancelled else { return }
                    alertTexts = ("Error", "\(error.displayMessage)")
                    presentAlert = true
                }
            }
        }
        /// Payment amount in minor units
        let amount = totalPrice * 100
        let options = PSApplePayTokenizeOptions(
            amount: amount,
            merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
            customerDetails: CustomerDetails(
                billingDetails: billingAddress.toBillingDetails(),
                profile: nil
            ),
            accountId: paymentManager.cardAccountId,
            currencyCode: "USD",
            psApplePay: PSApplePayItem(label: item.title)
        )
        applePayContext.tokenize(
            using: options,
            completion: completion
        )
    }

    func presentPayPal(using paymentManager: PaymentManager) {
        guard let payPalContext, let billingAddress, !isloading else { return }
        let completion: PSTokenizeBlock = { [weak self] tokenizeResult in
            guard let self else { return }
            asyncMain { [weak self] in
                guard let self else { return }
                isloading = false
                switch tokenizeResult {
                case let .success(paymentHandleToken):
                    orderConfirmationDetails = OrderConfirmationDetails(
                        accountId: paymentManager.paypalAccountId,
                        merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
                        paymentHandleToken: paymentHandleToken
                    )
                case let .failure(error):
                    guard error.errorCode != .payPalUserCancelled else { return }
                    alertTexts = ("Error", "\(error.displayMessage)")
                    presentAlert = true
                }
            }
        }
        /// Payment amount in minor units
        let amount = totalPrice * 100
        let options = PSPayPalTokenizeOptions(
            amount: amount,
            merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
            customerDetails: CustomerDetails(
                billingDetails: billingAddress.toBillingDetails(),
                profile: nil
            ),
            accountId: nil,
            currencyCode: "USD",
            consumerId: "consumer@gmail.com",
            recipientDescription: "My store description",
            language: .US,
            shippingPreference: .getFromFile,
            consumerMessage: "My note to payer",
            orderDescription: "My order description"
        )
        asyncMain { [weak self] in self?.isloading = true }
        payPalContext.tokenize(
            using: options,
            completion: completion
        )
    }
}
