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
    var profileIdPassed: String?
    var amountPassed: String = "0.0"
    
    override func initiateVenmoFlow(profileId: String?, amount: String) -> AnyPublisher<PSVenmoBraintreeResult, PSError> {
        profileIdPassed = profileId
        amountPassed = amount
        return Just(
            .success(venmoAccount: VenmoAccount(nonce: "fake-nonce", type: "", isDefault: true))
        )
        .setFailureType(to: PSError.self).eraseToAnyPublisher()
    }
}
