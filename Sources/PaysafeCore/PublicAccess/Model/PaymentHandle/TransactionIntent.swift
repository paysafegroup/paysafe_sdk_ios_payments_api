//
//  TransactionIntent.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This identifies the type of transaction being authenticated. This element is required only in certain markets, e.g., Brazil.
public enum TransactionIntent: String, Encodable {
    /// Goods or service purchase
    case goodsOrServicePurchase = "GOODS_OR_SERVICE_PURCHASE"
    /// Check acceptance
    case checkAcceptance = "CHECK_ACCEPTANCE"
    /// Account funding
    case accountFunding = "ACCOUNT_FUNDING"
    /// Quasi cash transaction
    case quasiCashTransaction = "QUASI_CASH_TRANSACTION"
    /// Prepaid activation
    case prepaidActivation = "PREPAID_ACTIVATION"

    /// TransactionIntentRequest
    var request: TransactionIntentRequest {
        switch self {
        case .goodsOrServicePurchase:
            return .goodsOrServicePurchase
        case .checkAcceptance:
            return .checkAcceptance
        case .accountFunding:
            return .accountFunding
        case .quasiCashTransaction:
            return .quasiCashTransaction
        case .prepaidActivation:
            return .prepaidActivation
        }
    }
}
