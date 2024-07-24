//
//  PSApplePayMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
@testable import PaysafeApplePay
import PaysafeCommon

public class PSApplePayMock: PSApplePay {
    public override func initiateApplePayFlow(currencyCode: String, amount: Double, psApplePay: PSApplePayItem) -> AnyPublisher<Result<InitializeApplePayResponse, PSError>, Never> {
        let initializeApplePayResponse = InitializeApplePayResponse(
            applePayPaymentToken: ApplePayPaymentToken(
                token: ApplePayToken(
                    paymentData: ApplePaymentData(
                        signature: "signature",
                        data: "data",
                        header: ApplePaymentHeader(
                            publicKeyHash: "publicKeyHash",
                            ephemeralPublicKey: "ephemeralPublicKey",
                            transactionId: "transactionId"
                        ),
                        version: "version"
                    ),
                    paymentMethod: ApplePaymentMethod(
                        displayName: "displayName",
                        network: "network",
                        type: "type"
                    ),
                    transactionIdentifier: "transactionIdentifier"
                ),
                billingContact: BillingContact(
                    addressLines: ["Cameron Road"],
                    countryCode: "US",
                    email: "john.doe@paysafe.com",
                    locality: "Lexington",
                    name: "John",
                    phone: "7164458829",
                    country: "United States",
                    postalCode: "14082",
                    administrativeArea: "Alabama"
                )
            ),
            completion: nil
        )
        return Just(.success(initializeApplePayResponse)).eraseToAnyPublisher()
    }
}
