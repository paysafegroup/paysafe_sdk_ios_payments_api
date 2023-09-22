//
//  AuthenticationPurpose.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Indicates the type of Authentication request. This data element provides additional information
/// to the ACS to determine the best approach for handing an authentication request.
public enum AuthenticationPurpose: String, Encodable {
    /// Payment transaction
    case paymentTransaction = "PAYMENT_TRANSACTION"
    /// Instalment transaction
    case instalmentTransaction = "INSTALMENT_TRANSACTION"

    /// AuthenticationPurposeRequest
    var request: AuthenticationPurposeRequest {
        switch self {
        case .paymentTransaction:
            return .paymentTransaction
        case .instalmentTransaction:
            return .instalmentTransaction
        }
    }
}
