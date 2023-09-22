//
//  PSApplePayMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
@testable import PaysafeApplePay
import PaysafeCommon

class PSApplePayMock: PSApplePay {
    override func initiateApplePayFlow(currencyCode: String, amount: Double, psApplePay: PSApplePayItem) -> AnyPublisher<Result<InitializeApplePayResponse, PSError>, Never> {
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
                )
            ),
            completion: nil
        )
        return Just(.success(initializeApplePayResponse)).eraseToAnyPublisher()
    }
}
