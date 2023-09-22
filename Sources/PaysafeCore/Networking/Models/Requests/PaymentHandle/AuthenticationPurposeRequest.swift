//
//  AuthenticationPurposeRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Indicates the type of Authentication request. This data element provides additional information
/// to the ACS to determine the best approach for handing an authentication request.
enum AuthenticationPurposeRequest: String, Encodable {
    /// Payment transaction
    case paymentTransaction = "PAYMENT_TRANSACTION"
    /// Recurring transaction
    case recurringTransaction = "RECURRING_TRANSACTION"
    /// Add card
    case addCard = "ADD_CARD"
    /// Maintain a card
    case maintainCard = "MAINTAIN_CARD"
    /// Emv token verification
    case emvTokenVerification = "EMV_TOKEN_VERIFICATION"
    /// Instalment transaction
    case instalmentTransaction = "INSTALMENT_TRANSACTION"
}
