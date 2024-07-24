//
//  VenmoRequest.swift
//  
//
//  Created by Eduardo Oliveros on 5/28/24.
//

import Foundation

/// VenmoRequest
struct VenmoRequest: Encodable {
    /// Consumer id
    let consumerId: String
    /// MerchantAccountId
    let merchantAccountId: String?
    /// ProfileId
    let profileId: String?
}
