//
//  PSAPIClientMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PaysafeCommon
@testable import PaysafeCore
import XCTest

class PSAPIClientMock: PSAPIClient {
    var tokenizeShouldFail = false
    var expectedTokenizeResultStatus: PaymentHandleTokenStatus = .payable
    override func tokenize(options: PSTokenizable, paymentType: PaymentType, card: CardRequest?) -> AnyPublisher<PaymentHandle, PSError> {
        switch tokenizeShouldFail {
        case true:
            return Fail(error: .genericAPIError("correlationId")).eraseToAnyPublisher()
        case false:
            return Just(
                PaymentHandle(
                    accountId: "accountId",
                    status: expectedTokenizeResultStatus,
                    merchantRefNum: "merchantRefNum",
                    paymentHandleToken: String(repeating: "*", count: 16),
                    redirectPaymentLink: ReturnLink(
                        rel: .redirectPayment,
                        href: "https://paysafe.com",
                        method: nil
                    ),
                    returnLinks: [
                        ReturnLink(
                            rel: .defaultAction,
                            href: "https://paysafe.com/return",
                            method: nil
                        ),
                        ReturnLink(
                            rel: .onCompleted,
                            href: "https://paysafe.com/return/success",
                            method: nil
                        ),
                        ReturnLink(
                            rel: .onFailed,
                            href: "https://paysafe.com/return/failed",
                            method: nil
                        ),
                        ReturnLink(
                            rel: .onCancelled,
                            href: "https://paysafe.com/return/cancelled",
                            method: nil
                        )
                    ],
                    orderId: "orderId"
                )
            )
            .setFailureType(to: PSError.self)
            .eraseToAnyPublisher()
        }
    }

    var getPaymentMethodShouldFail = false
    var getPaymentMethodShouldSucceedCardPaymentValidation = false
    var getPaymentMethodShouldFailCardPaymentValidation = false
    var getPaymentMethodShouldSucceedApplePayValidation = false
    var getPaymentMethodShouldFailApplePayValidation = false
    var getPaymentMethodShouldSucceedPayPalValidation = false
    var getPaymentMethodShouldFailPayPalValidation = false
    override func getPaymentMethod(currencyCode: String, accountId: String, completion: @escaping PSPaymentMethodBlock) {
        switch getPaymentMethodShouldFail {
        case true:
            completion(.failure(.coreMerchantAccountConfigurationError("correlationId")))
        case false:
            switch true {
            case getPaymentMethodShouldSucceedCardPaymentValidation, getPaymentMethodShouldFailApplePayValidation:
                let paymentMethod = PaymentMethod(
                    paymentMethod: .card,
                    currencyCode: currencyCode,
                    accountId: accountId,
                    accountConfiguration: AccountConfiguration(
                        id: "id",
                        isApplePay: false,
                        cardTypeConfig: [
                            "VI": "BOTH",
                            "MD": "BOTH",
                            "MC": "BOTH",
                            "DI": "BOTH",
                            "AM": "BOTH"
                        ],
                        clientId: "testClientId"
                    )
                )
                completion(.success(paymentMethod))
            case getPaymentMethodShouldSucceedApplePayValidation, getPaymentMethodShouldFailPayPalValidation:
                let paymentMethod = PaymentMethod(
                    paymentMethod: .card,
                    currencyCode: currencyCode,
                    accountId: accountId,
                    accountConfiguration: AccountConfiguration(
                        id: "id",
                        isApplePay: true,
                        cardTypeConfig: [
                            "VI": "BOTH",
                            "MD": "BOTH",
                            "MC": "BOTH",
                            "DI": "BOTH",
                            "AM": "BOTH"
                        ],
                        clientId: "testClientId"
                    )
                )
                completion(.success(paymentMethod))
            case getPaymentMethodShouldSucceedPayPalValidation, getPaymentMethodShouldFailCardPaymentValidation:
                let paymentMethod = PaymentMethod(
                    paymentMethod: .payPal,
                    currencyCode: currencyCode,
                    accountId: accountId,
                    accountConfiguration: AccountConfiguration(
                        id: "id",
                        isApplePay: false,
                        cardTypeConfig: nil,
                        clientId: "payPalClientId"
                    )
                )
                completion(.success(paymentMethod))
            default:
                XCTFail("At least one `shouldFail` or `shouldSucceed` flag should be enabled.")
            }
        }
    }

    var refreshPaymentTokenShouldFail = false
    override func refreshPaymentToken(using paymentHandleToken: String, and retryCount: Int = 3, and delayInSeconds: TimeInterval = 6) -> AnyPublisher<Void, PSError> {
        switch refreshPaymentTokenShouldFail {
        case true:
            return Fail(error: .genericAPIError("correlationId")).eraseToAnyPublisher()
        case false:
            return Just(()).setFailureType(to: PSError.self).eraseToAnyPublisher()
        }
    }
}
