//
//  File.swift
//  
//
//  Created by Eduardo Oliveros on 5/28/24.
//

import Combine
import Foundation
import PaysafeCommon
@testable import PaysafeVenmo

class PSVenmoMock: PSVenmo {
    override func initiateVenmoFlow(profileId: String, amount: Int) -> AnyPublisher<PSVenmoBraintreeResult, PSError> {
        Just(
            .success(venmoAccount: VenmoAccount(nonce: "fake-nonce", type: "", isDefault: true))
        )
        .setFailureType(to: PSError.self).eraseToAnyPublisher()
    }
}
