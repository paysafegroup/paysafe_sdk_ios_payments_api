//
//  PSTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation
@testable import PaysafeCore

extension PSTokenizeOptions {
    static func mockForNewCardPayment(accountId: String) -> PSTokenizeOptions {
        PSTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            customerDetails: CustomerDetails(
                billingDetails: BillingDetails(
                    country: "US",
                    zip: "33172",
                    state: "FL",
                    city: nil,
                    street: nil,
                    street1: nil,
                    street2: nil,
                    phone: nil,
                    nickName: nil
                ),
                profile: Profile(
                    firstName: "John",
                    lastName: "Doe",
                    email: nil,
                    phone: nil,
                    cellPhone: nil
                )
            ),
            accountId: accountId,
            merchantDescriptor: MerchantDescriptor(
                dynamicDescriptor: "testMerchantDescriptor",
                phone: "testPhone"
            ),
            threeDS: ThreeDS(
                merchantUrl: "https://api.qa.paysafe.com/checkout/v2/index.html#/desktop",
                maxAuthorizationsForInstalmentPayment: 3,
                billingCycle: BillingCycle(
                    endDate: "testEndDate",
                    frequency: 10
                ),
                electronicDelivery: ElectronicDelivery(
                    isElectronicDelivery: true,
                    email: "testEmail"
                ),
                profile: Profile(
                    firstName: "John",
                    lastName: "Doe",
                    email: "john.doe@gmail.com",
                    phone: "testPhone",
                    cellPhone: "testCellPhone"
                ),
                messageCategory: MessageCategory.payment,
                requestorChallengePreference: .noPreference,
                transactionIntent: .goodsOrServicePurchase,
                initialPurchaseTime: "20-11-2023",
                orderItemDetails: OrderItemDetails(
                    preOrderItemAvailabilityDate: "",
                    preOrderPurchaseIndicator: "",
                    reorderItemsIndicator: "",
                    shippingIndicator: ""
                ),
                purchasedGiftCardDetails: PurchasedGiftCardDetails(
                    amount: 10,
                    count: 10,
                    currency: "USD"
                ),
                userAccountDetails: UserAccountDetails(
                    createdDate: nil,
                    createdRange: CreatedRange.from30To60Days,
                    changedDate: nil,
                    changedRange: .from30To60Days,
                    passwordChangedDate: nil,
                    passwordChangedRange: nil,
                    totalPurchasesSixMonthCount: nil,
                    transactionCountForPreviousDay: nil,
                    transactionCountForPreviousYear: nil,
                    suspiciousAccountActivity: nil,
                    shippingDetailsUsage: ShippingDetailsUsage(
                        cardHolderNameMatch: true,
                        initialUsageDate: "20-11-2023",
                        initialUsageRange: .from30To60Days
                    ),
                    paymentAccountDetails: PaymentAccountDetails(
                        createdDate: nil,
                        createdRange: nil
                    ),
                    userLogin: UserLogin(
                        data: nil,
                        authenticationMethod: nil,
                        time: nil
                    ),
                    priorThreeDSAuthentication: PriorThreeDSAuthentication(
                        data: nil,
                        method: nil,
                        id: nil,
                        time: nil
                    ),
                    travelDetails: TravelDetails(
                        isAirTravel: true,
                        airlineCarrier: "TAROM",
                        departureDate: "25-11-2023",
                        destination: "Bulgaria",
                        origin: "Cluj",
                        passengerFirstName: "John Doe",
                        passengerLastName: "Smith"
                    )
                )
            ),
            renderType: .both
        )
    }

    static func mockForSavedCardPayment(accountId: String) -> PSTokenizeOptions {
        PSTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            customerDetails: CustomerDetails(
                billingDetails: BillingDetails(
                    country: "US",
                    zip: "33172",
                    state: "FL",
                    city: nil,
                    street: nil,
                    street1: nil,
                    street2: nil,
                    phone: nil,
                    nickName: nil
                ),
                profile: Profile(
                    firstName: "John",
                    lastName: "Doe",
                    email: nil,
                    phone: nil,
                    cellPhone: nil
                )
            ),
            accountId: accountId,
            merchantDescriptor: MerchantDescriptor(
                dynamicDescriptor: "testMerchantDescriptor",
                phone: "testPhone"
            ),
            threeDS: ThreeDS(
                merchantUrl: "https://api.qa.paysafe.com/checkout/v2/index.html#/desktop",
                maxAuthorizationsForInstalmentPayment: 3,
                billingCycle: BillingCycle(
                    endDate: "testEndDate",
                    frequency: 10
                ),
                electronicDelivery: ElectronicDelivery(
                    isElectronicDelivery: true,
                    email: "testEmail"
                ),
                profile: Profile(
                    firstName: "John",
                    lastName: "Doe",
                    email: "john.doe@gmail.com",
                    phone: "testPhone",
                    cellPhone: "testCellPhone"
                ),
                messageCategory: MessageCategory.payment,
                requestorChallengePreference: .noPreference,
                transactionIntent: .goodsOrServicePurchase,
                initialPurchaseTime: "20-11-2023",
                orderItemDetails: OrderItemDetails(
                    preOrderItemAvailabilityDate: "",
                    preOrderPurchaseIndicator: "",
                    reorderItemsIndicator: "",
                    shippingIndicator: ""
                ),
                purchasedGiftCardDetails: PurchasedGiftCardDetails(
                    amount: 10,
                    count: 10,
                    currency: "USD"
                ),
                userAccountDetails: UserAccountDetails(
                    createdDate: nil,
                    createdRange: CreatedRange.from30To60Days,
                    changedDate: nil,
                    changedRange: .from30To60Days,
                    passwordChangedDate: nil,
                    passwordChangedRange: nil,
                    totalPurchasesSixMonthCount: nil,
                    transactionCountForPreviousDay: nil,
                    transactionCountForPreviousYear: nil,
                    suspiciousAccountActivity: nil,
                    shippingDetailsUsage: ShippingDetailsUsage(
                        cardHolderNameMatch: true,
                        initialUsageDate: "20-11-2023",
                        initialUsageRange: .from30To60Days
                    ),
                    paymentAccountDetails: PaymentAccountDetails(
                        createdDate: nil,
                        createdRange: nil
                    ),
                    userLogin: UserLogin(
                        data: nil,
                        authenticationMethod: nil,
                        time: nil
                    ),
                    priorThreeDSAuthentication: PriorThreeDSAuthentication(
                        data: nil,
                        method: nil,
                        id: nil,
                        time: nil
                    ),
                    travelDetails: TravelDetails(
                        isAirTravel: true,
                        airlineCarrier: "TAROM",
                        departureDate: "25-11-2023",
                        destination: "Bulgaria",
                        origin: "Cluj",
                        passengerFirstName: "John Doe",
                        passengerLastName: "Smith"
                    )
                )
            ),
            singleUseCustomerToken: "testSingleuseCustomerToken",
            paymentTokenFrom: "testPaymentTokenFrom",
            renderType: .both
        )
    }
}
