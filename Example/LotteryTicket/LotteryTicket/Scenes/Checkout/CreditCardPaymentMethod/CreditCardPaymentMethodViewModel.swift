//
//  CreditCardPaymentMethodViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments
import SwiftUI

final class CreditCardPaymentMethodViewModel: ObservableObject {
    let billingAddress: BillingAddress?
    let totalPrice: Double

    @Published var savedCards: [SavedCard] = []
    @Published var isloading = false
    private var isFirstLaunch = true

    /// MerchantBackend
    private let merchantBackend: MerchantBackend

    init(billingAddress: BillingAddress?, totalPrice: Double) {
        self.billingAddress = billingAddress
        self.totalPrice = totalPrice
        merchantBackend = MerchantBackend(apiKey: DemoConfig.merchantBackendApiKey)
    }

    func onAppear() {
        guard isFirstLaunch, !isloading else { return }
        isFirstLaunch = false
        isloading = true
        merchantBackend.fetchSavedCards(for: DemoConfig.profileId) { [weak self] result in
            asyncMain { [weak self] in
                guard let self else { return }
                isloading = false
                switch result {
                case let .success(response):
                    savedCards = response.paymentHandles?.compactMap { $0.toSavedCard(response.singleUseCustomerToken) } ?? []
                case let .failure(error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
