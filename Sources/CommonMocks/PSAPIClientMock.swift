//
//  PSAPIClientMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
@testable import PaysafeCommon
import XCTest

public class PSAPIClientMock: PSAPIClient {
    public var tokenizeShouldFail = false
    public var expectedTokenizeResultStatus: PaymentHandleTokenStatus = .payable
    public var paymentHandleId = "id"
    
    public override func tokenize(options: PSTokenizable, paymentType: PaymentType, card: CardRequest?) -> AnyPublisher<PaymentHandle, PSError> {
        self.renderType = .html
        switch tokenizeShouldFail {
        case true:
            return Fail(error: .genericAPIError("correlationId")).eraseToAnyPublisher()
        case false:
            return Just(
                PaymentHandle(
                    id: paymentHandleId,
                    accountId: "accountId",
                    card: CardResponse(cardBin: "12345", networkToken: NetworkToken(bin: "1234")),
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
                    orderId: "orderId", 
                    gatewayResponse: nil, 
                    action: "REDIRECT"
                )
            )
            .setFailureType(to: PSError.self)
            .eraseToAnyPublisher()
        }
    }

    public var getPaymentMethodShouldFail = false
    public var getPaymentMethodShouldSucceedCardPaymentValidation = false
    public var getPaymentMethodShouldFailCardPaymentValidation = false
    public var getPaymentMethodShouldSucceedApplePayValidation = false
    public var getPaymentMethodShouldFailApplePayValidation = false

    public override func getPaymentMethod(currencyCode: String, accountId: String, completion: @escaping PSPaymentMethodBlock) {
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
            case getPaymentMethodShouldSucceedApplePayValidation:
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
            case getPaymentMethodShouldFailCardPaymentValidation:
                let paymentMethod = PaymentMethod(
                    paymentMethod: .venmo,
                    currencyCode: currencyCode,
                    accountId: accountId,
                    accountConfiguration: AccountConfiguration(
                        id: "id",
                        isApplePay: false,
                        cardTypeConfig: nil,
                        clientId: "clientId"
                    )
                )
                completion(.success(paymentMethod))
            default:
                XCTFail("At least one `shouldFail` or `shouldSucceed` flag should be enabled.")
            }
        }
    }

    public var refreshPaymentTokenShouldFail = false
    public override func refreshPaymentToken(using paymentHandleToken: String, and retryCount: Int = 3, and delayInSeconds: TimeInterval = 6) -> AnyPublisher<String, PSError> {
        switch refreshPaymentTokenShouldFail {
        case true:
            return Fail(error: .genericAPIError("correlationId")).eraseToAnyPublisher()
        case false:
            return Just("token").setFailureType(to: PSError.self).eraseToAnyPublisher()
        }
    }
}
