//
//  CreditCardPaymentMethodViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCore
import SwiftUI

final class CreditCardPaymentMethodViewModel: ObservableObject {
    let billingAddress: BillingAddress?
    let totalPrice: Double

    @Published var savedCards: [SavedCard] = []
    @Published var isloading = false
    private var isFirstLaunch = true

    /// MerchantBackend
    private let merchantBackend: MerchantBackend
    /// API key
    private let apiKey = "dGVzdF9ob3N0ZWQ6Qi1xYTItMC02MDRiM2RiNS0wLTMwMmMwMjE0N2FkYTNjYTQyMGI0N2Q4ZWI5ODEyMjYzZDQ5NGJhOTU3MTRlMTQ0ZDAyMTQwMzgyMWUzYTMzZWJmMmQwMDYyNjgyZWQwNDk1MGM3ZWJjMzE5ZmFm"
    /// Profile id
    private let profileId = "284f1502-0cad-4256-b5e5-705ed06cfbbd"

    init(billingAddress: BillingAddress?, totalPrice: Double) {
        self.billingAddress = billingAddress
        self.totalPrice = totalPrice
        merchantBackend = MerchantBackend(apiKey: apiKey)
    }

    func onAppear() {
        guard isFirstLaunch, !isloading else { return }
        isFirstLaunch = false
        isloading = true
        merchantBackend.fetchSavedCards(for: profileId) { [weak self] result in
            asyncMain { [weak self] in
                guard let self else { return }
                isloading = false
                switch result {
                case let .success(response):
                    savedCards = response.paymentHandles.compactMap { $0.toSavedCard(response.singleUseCustomerToken) }
                case let .failure(error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
