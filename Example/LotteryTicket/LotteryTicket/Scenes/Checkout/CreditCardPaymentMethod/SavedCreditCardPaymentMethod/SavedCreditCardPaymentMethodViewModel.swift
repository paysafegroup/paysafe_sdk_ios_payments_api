//
//  SavedCreditCardPaymentMethodViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments
import SwiftUI

final class SavedCreditCardPaymentMethodViewModel: ObservableObject {
    @Published private(set) var isInitializing = true
    @Published private(set) var placeOrderEnabled = false
    @Published private(set) var isloading = false
    @Published var presentAlert = false
    @Published var orderConfirmationDetails: OrderConfirmationDetails?

    private var cardForm: PSCardForm?

    private var alertTexts: (title: String, message: String)?
    var alertTitle: String { alertTexts?.title ?? "" }
    var alertMessage: String { alertTexts?.message ?? "" }

    let billingAddress: BillingAddress?
    let totalPrice: Double
    let savedCard: SavedCard

    init(
        billingAddress: BillingAddress?,
        totalPrice: Double,
        savedCard: SavedCard
    ) {
        self.billingAddress = billingAddress
        self.totalPrice = totalPrice
        self.savedCard = savedCard
    }

    func configureCardForm(
        paymentManager: PaymentManager,
        cardholderNameView: PSCardholderNameInputSwiftUIView,
        cardCVVView: PSCardCVVInputSwiftUIView
    ) {
        guard isInitializing else { return }
        PSCardForm.initialize(
            currencyCode: "USD",
            accountId: paymentManager.cardAccountId,
            cardholderNameSwiftUIView: cardholderNameView,
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
            ),
            singleUseCustomerToken: savedCard.singleUseCustomerToken,
            paymentTokenFrom: savedCard.paymentTokenFrom
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
}
