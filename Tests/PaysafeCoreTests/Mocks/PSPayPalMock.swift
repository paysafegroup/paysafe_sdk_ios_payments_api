//
//  PSPayPalMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import Foundation
import PaysafeCommon
@testable import PaysafePayPal

class PSPayPalMock: PSPayPal {
    override func initiatePayPalFlow(orderId: String, payPalLinks: PSPayPalLinks) -> AnyPublisher<PSPayPalResult, PSError> {
        Just(.success).setFailureType(to: PSError.self).eraseToAnyPublisher()
    }
}
