//
//  TransactionTypeResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This specifies the transaction type for which the Payment Handle is created. Possible values are:
/// PAYMENT - Payment Handle is created to continue the Payment.
/// STANDOLNE_CREDIT, ORIGINAL_CREDIT, VERIFICATION
enum TransactionTypeResponse: String, Decodable {
    /// Payment
    case payment = "PAYMENT"
    /// Standalone credit
    case standaloneCredit = "STANDALONE_CREDIT"
    /// Original credit
    case originalCredit = "ORIGINAL_CREDIT"
    /// Verification
    case verification = "VERIFICATION"
}
