//
//  PaymentMethodsViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeApplePay
import PaysafeVenmo
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
    private var venmoContext: PSVenmoContext?
    
    private var alertTexts: (title: String, message: String)?
    var alertTitle: String { alertTexts?.title ?? "" }
    var alertMessage: String { alertTexts?.message ?? "" }
    
    private var isFirstLaunch = true
    
    private let dispatchGroup = DispatchGroup()
    private var temporaryPaymentMethods: [(paymentMethod: PaymentMethod, isAvailable: Bool)] = [
        (.creditCard, true),
        (.venmo, false),
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
        
        initializeVenmoContext(using: paymentManager)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            isloading = false
            paymentMethods = temporaryPaymentMethods
                .filter(\.isAvailable)
                .map(\.paymentMethod)
        }
        isFirstLaunch = false
    }
    
    func initializeVenmoContext(using paymentManager: PaymentManager) {
        dispatchGroup.enter()
        
        PSVenmoContext.initialize(
            currencyCode: "USD",
            accountId: paymentManager.venmoAccountId
        ) { [weak self] result in
            asyncMain { [weak self] in
                guard let self else { return }
                switch result {
                case let .success(venmoContext):
                    self.venmoContext = venmoContext
                    if let index = temporaryPaymentMethods.firstIndex(where: { $0.paymentMethod == .venmo }) {
                        temporaryPaymentMethods[index].isAvailable = true
                    }
                case .failure:
                    break
                }
                dispatchGroup.leave()
            }
        }
    }
    
    func presentApplePay(using paymentManager: PaymentManager) {
        guard let applePayContext, let item else { return }
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
        let amount = Int(totalPrice * 100)
        let options = PSApplePayTokenizeOptions(
            amount: amount,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
            billingDetails: billingAddress?.toBillingDetails(),
            accountId: paymentManager.cardAccountId,
            psApplePay: PSApplePayItem(
                label: item.title,
                requestBillingAddress: true
            )
        )
        applePayContext.tokenize(
            using: options,
            completion: completion
        )
    }
    
    func presentVenmo(using paymentManager: PaymentManager) {
        guard let venmoContext, let billingAddress, !isloading else { return }
        
        let completion: PSTokenizeBlock = { [weak self] tokenizeResult in
            guard let self else { return }
            asyncMain { [weak self] in
                guard let self else { return }
                isloading = false
                switch tokenizeResult {
                case let .success(paymentHandleToken):
                    orderConfirmationDetails = OrderConfirmationDetails(
                        accountId: paymentManager.venmoAccountId,
                        merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
                        paymentHandleToken: paymentHandleToken
                    )
                case let .failure(error):
                    alertTexts = ("Error", error.displayMessage)
                    presentAlert = true
                }
            }
        }
        
        /// Payment amount in minor units
        let amount = Int(totalPrice * 100)
        let options = PSVenmoTokenizeOptions(
            amount: amount,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: PaysafeSDK.shared.getMerchantReferenceNumber(),
            billingDetails: billingAddress.toBillingDetails(),
            profile: Profile(
                firstName: "Robert",
                lastName: "Furious",
                locale: .en_US,
                merchantCustomerId: nil,
                dateOfBirth: nil,
                email: "name.name@mail.com",
                phone: nil,
                mobile: nil,
                gender: nil,
                nationality: nil,
                identityDocuments: nil
            ),
            accountId: paymentManager.venmoAccountId,
            dupCheck: false,
            venmo: VenmoAdditionalData(
                consumerId: "consumerId+\(UUID().uuidString)",
                profileId: "4013002571644081777"
            )
        )
        asyncMain { [weak self] in self?.isloading = true }
        
        
        venmoContext.tokenize(
            using: options,
            completion: completion
        )
    }
}
