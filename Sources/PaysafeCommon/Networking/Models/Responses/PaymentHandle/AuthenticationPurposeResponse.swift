//
//  AuthenticationPurposeResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Indicates the type of Authentication request. This data element provides additional information
/// to the ACS to determine the best approach for handing an authentication request.
enum AuthenticationPurposeResponse: String, Decodable {
    /// Payment transaction
    case paymentTransaction = "PAYMENT_TRANSACTION"
    /// Instalment transaction
    case instalmentTransaction = "INSTALMENT_TRANSACTION"
}
