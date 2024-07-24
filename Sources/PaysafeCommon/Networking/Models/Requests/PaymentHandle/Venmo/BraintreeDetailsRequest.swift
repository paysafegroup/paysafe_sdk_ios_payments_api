//
//  BraintreeDetailsRequest.swift
//  
//
//  Created by Eduardo Oliveros on 6/17/24.
//

import Foundation

public struct BraintreeDetailsRequest: Encodable {
    public let paymentMethodJwtToken: String
    public let paymentMethodNonce: String
    public let paymentMethodDeviceData: String
    public let errorCode: Int
    public let paymentMethodPayerInfo: String
    public init(paymentMethodJwtToken: String, paymentMethodNonce: String, paymentMethodDeviceData: String, errorCode: Int, paymentMethodPayerInfo: String) {
        self.paymentMethodJwtToken = paymentMethodJwtToken
        self.paymentMethodNonce = paymentMethodNonce
        self.paymentMethodDeviceData = paymentMethodDeviceData
        self.errorCode = errorCode
        self.paymentMethodPayerInfo = paymentMethodPayerInfo
    }
}
