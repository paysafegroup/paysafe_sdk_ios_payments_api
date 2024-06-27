//
//  BraintreeDetailsRequest.swift
//  
//
//  Created by Eduardo Oliveros on 6/17/24.
//

import Foundation

struct BraintreeDetailsRequest: Encodable {
    let paymentMethodJwtToken: String
    let paymentMethodNonce: String
    let paymentMethodDeviceData: String
    let errorCode: Int
    let paymentMethodPayerInfo: String
}
