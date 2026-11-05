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
    var collectDeviceDataClientMetadataIdPassed: String?
    var collectDeviceDataReturnValue: String = ""
    var initiateVenmoFlowResult: PSVenmoBraintreeResult = .success(
        venmoAccount: VenmoAccount(nonce: "fake-nonce",
                                   type: "",
                                   isDefault: true)
    )

    override func initiateVenmoFlow(profileId: String?, amount: String) -> AnyPublisher<PSVenmoBraintreeResult, PSError> {
        profileIdPassed = profileId
        amountPassed = amount
        return Just(initiateVenmoFlowResult)
        .setFailureType(to: PSError.self).eraseToAnyPublisher()
    }

    override func collectDeviceData(clientMetadataId: String?) -> AnyPublisher<String, Never> {
        collectDeviceDataClientMetadataIdPassed = clientMetadataId
        return Just(collectDeviceDataReturnValue).eraseToAnyPublisher()
    }
}
