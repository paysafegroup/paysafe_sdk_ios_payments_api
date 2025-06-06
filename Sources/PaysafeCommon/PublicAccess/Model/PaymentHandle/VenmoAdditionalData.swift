//
//  VenmoAdditionalData.swift
//
//
//  Created by Eduardo Oliveros on 5/28/24.
//

import Foundation

/// VenmoAdditionalData
public struct VenmoAdditionalData: Encodable {
    /// Consumer id
    public let consumerId: String
    /// MerchantAccountId
    public let merchantAccountId: String?
    /// ProfileId
    public let profileId: String?

    /// Public initializer required in order to be used in a different module.
    public init(consumerId: String, merchantAccountId: String? = nil, profileId: String? = nil) {
        self.consumerId = consumerId
        self.merchantAccountId = merchantAccountId
        self.profileId = profileId
    }

    /// VenmoRequest
    var request: VenmoRequest {
        VenmoRequest(
            consumerId: consumerId,
            merchantAccountId: merchantAccountId,
            profileId: profileId
        )
    }
}
