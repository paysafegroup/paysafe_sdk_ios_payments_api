//
//  TransactionIntentRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This identifies the type of transaction being authenticated. This element is required only in certain markets, e.g., Brazil.
enum TransactionIntentRequest: String, Encodable {
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
}
