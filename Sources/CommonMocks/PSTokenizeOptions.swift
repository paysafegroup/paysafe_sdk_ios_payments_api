//
//  PSTokenizeOptions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation
@testable import PaysafeCommon

public extension PSCardTokenizeOptions {
    static func mockForNewCardPayment(accountId: String) -> PSCardTokenizeOptions {
        PSCardTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            profile: Profile(
                firstName: "John",
                lastName: "Doe",
                locale: .en_GB,
                merchantCustomerId: "merchantCustomerId",
                dateOfBirth: DateOfBirth(
                    day: 20,
                    month: 6,
                    year: 1991
                ),
                email: "john.doe@paysafe.com",
                phone: "319493030030",
                mobile: "32919399439",
                gender: .male,
                nationality: "USA",
                identityDocuments: [.init(
                    documentNumber: "1923929319"
                )]
            ),
            accountId: accountId,
            merchantDescriptor: MerchantDescriptor(
                dynamicDescriptor: "testMerchantDescriptor",
                phone: "testPhone"
            ),
            shippingDetails: ShippingDetails(
                shipMethod: .nextDay,
                street: "Delivery street",
                street2: "Delivery street 2",
                city: nil,
                state: "Texas",
                country: nil,
                zip: "400234"
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
                profile: ThreeDSProfile(
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
                    passwordChangedRange: .noChange,
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
                        data: "no data available",
                        authenticationMethod: .noLogin,
                        time: "23:12:05"
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

    static func mockForSavedCardPayment(accountId: String) -> PSCardTokenizeOptions {
        PSCardTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            accountId: accountId,
            merchantDescriptor: MerchantDescriptor(
                dynamicDescriptor: "testMerchantDescriptor",
                phone: "testPhone"
            ),
            shippingDetails: ShippingDetails(
                shipMethod: .lowestCost,
                street: "Delivery street",
                street2: "Delivery street 2",
                city: nil,
                state: "Texas",
                country: nil,
                zip: "400234"
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
                profile: ThreeDSProfile(
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
                        data: "no data available",
                        authenticationMethod: .internalCredentials,
                        time: "20:12:34"
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

    static func mockForSavedCardPayment(
        accountId: String,
        shipMethod: ShipMethodRequest
    ) -> PSCardTokenizeOptions {
        PSCardTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            accountId: accountId,
            merchantDescriptor: MerchantDescriptor(
                dynamicDescriptor: "testMerchantDescriptor",
                phone: "testPhone"
            ),
            shippingDetails: ShippingDetails(
                shipMethod: ShipMethod(rawValue: shipMethod.rawValue),
                street: "Delivery street",
                street2: "Delivery street 2",
                city: nil,
                state: "Texas",
                country: nil,
                zip: "400234"
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
                profile: ThreeDSProfile(
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
                        data: "no data available",
                        authenticationMethod: .internalCredentials,
                        time: "20:12:34"
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

    static func mockForApplePay(accountId: String) -> PSApplePayTokenizeOptions {
        var tokenizeOptions = PSApplePayTokenizeOptions(
            amount: 1000,
            currencyCode: "USD",
            transactionType: .payment,
            merchantRefNum: UUID().uuidString,
            profile: Profile(
                firstName: "John",
                lastName: "Doe",
                locale: .en_GB,
                merchantCustomerId: "merchantCustomerId",
                dateOfBirth: DateOfBirth(
                    day: 20,
                    month: 6,
                    year: 1991
                ),
                email: "john.doe@paysafe.com",
                phone: "319493030030",
                mobile: "32919399439",
                gender: .male,
                nationality: "USA",
                identityDocuments: [.init(
                    documentNumber: "1923929319"
                )]
            ),
            accountId: accountId,
            merchantDescriptor: MerchantDescriptor(
                dynamicDescriptor: "testMerchantDescriptor",
                phone: "testPhone"
            ),
            shippingDetails: ShippingDetails(
                shipMethod: .nextDay,
                street: "Delivery street",
                street2: "Delivery street 2",
                city: nil,
                state: "Texas",
                country: nil,
                zip: "400234"
            ),
            psApplePay: PSApplePayItem(
                label: "Customer Store",
                requestBillingAddress: false
            )
        )
        tokenizeOptions.applePay = ApplePayAdditionalData(
            label: "Apple pay",
            requestBillingAddress: false,
            applePayPaymentToken: ApplePayPaymentTokenRequest(
                token: .init(
                    paymentData: nil,
                    paymentMethod: .init(
                        displayName: nil,
                        network: nil,
                        type: "apple pay"
                    ),
                    transactionIdentifier: "testIdentifier"
                ),
                billingContact: nil
            )
        )
        return tokenizeOptions
    }
}
