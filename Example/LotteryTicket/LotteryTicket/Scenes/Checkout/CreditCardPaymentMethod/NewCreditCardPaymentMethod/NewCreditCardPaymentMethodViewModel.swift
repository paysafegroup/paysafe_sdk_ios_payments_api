//
//  NewCreditCardPaymentMethodViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCore
import SwiftUI

final class NewCreditCardPaymentMethodViewModel: ObservableObject {
    @Published private(set) var isInitializing = true
    @Published private(set) var placeOrderEnabled = false
    @Published private(set) var isloading = false
    @Published var presentAlert = false
    @Published var orderConfirmationDetails: OrderConfirmationDetails?

    private var cardForm: PSCardForm?

    private var alertTexts: (title: String, message: String)?
    var alertTitle: String { alertTexts?.title ?? "" }
    var alertMessage: String { alertTexts?.message ?? "" }

    private let billingAddress: BillingAddress?
    private let totalPrice: Double

    init(
        billingAddress: BillingAddress?,
        totalPrice: Double
    ) {
        self.billingAddress = billingAddress
        self.totalPrice = totalPrice
    }

    func configureCardForm(
        paymentManager: PaymentManager,
        cardNumberView: PSCardNumberInputSwiftUIView,
        cardholderNameView: PSCardholderNameInputSwiftUIView,
        cardExpiryView: PSCardExpiryInputSwiftUIView,
        cardCVVView: PSCardCVVInputSwiftUIView
    ) {
        guard isInitializing else { return }
        PSCardForm.initialize(
            currencyCode: "USD",
            accountId: paymentManager.cardAccountId,
            cardNumberSwiftUIView: cardNumberView,
            cardholderNameSwiftUIView: cardholderNameView,
            cardExpirySwiftUIView: cardExpiryView,
            cardCVVSwiftUIView: cardCVVView
        ) { [weak self] result in
            asyncMain { [weak self] in
                guard let self else { return }
                isInitializing = false
                switch result {
                case let .success(cardForm):
                    self.cardForm = cardForm
                    cardForm.onCardFormUpdate = { isValid in
                        asyncMain { [weak self] in self?.placeOrderEnabled = isValid }
                    }
                case let .failure(error):
                    alertTexts = ("Error", "\(error.displayMessage)")
                    presentAlert = true
                }
            }
        }
    }

    func didTapPlaceOrder(using paymentManager: PaymentManager) {
        guard let cardForm, let billingAddress else { return }
        isloading = true
        /// Payment amount in minor units
        let amount = Int(totalPrice * 100)
        let options = PSCardTokenizeOptions(
            amount: amount,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
            billingDetails: billingAddress.toBillingDetails(),
            accountId: paymentManager.cardAccountId,
            threeDS: ThreeDS(
                merchantUrl: "https://api.qa.paysafe.com/checkout/v2/index.html#/desktop",
                process: true
            )
        )
        let completion: PSTokenizeBlock = { [weak self] tokenizeResult in
            asyncMain { [weak self] in
                guard let self else { return }
                isloading = false
                switch tokenizeResult {
                case let .success(paymentHandleToken):
                    orderConfirmationDetails = OrderConfirmationDetails(
                        accountId: paymentManager.cardAccountId,
                        merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
                        paymentHandleToken: paymentHandleToken
                    )
                case let .failure(error):
                    guard error.errorCode != .threeDSUserCancelled else { return }
                    alertTexts = ("Error", "\(error.displayMessage)")
                    presentAlert = true
                }
            }
        }
        cardForm.tokenize(
            using: options,
            completion: completion
        )
    }

    func didSingleTap() {
        guard let cardForm else { return }
        alertTexts = ("Card brand", "\(cardForm.getCardBrand())")
        presentAlert = true
    }

    func didDoubleTap() {
        guard let cardForm else { return }
        alertTexts = ("Are all fields valid", "\(cardForm.areAllFieldsValid())")
        presentAlert = true
    }
}
