//
//  CreatedRangeRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// CreatedRangeRequest
enum CreatedRangeRequest: String, Encodable {
    /// During transaction
    case duringTransaction = "DURING_TRANSACTION"
    /// No account
    case noAccount = "NO_ACCOUNT"
    /// Less than 30 days
    case lessThan30Days = "LESS_THAN_THIRTY_DAYS"
    /// From 30 to 60 days
    case from30To60Days = "THIRTY_TO_SIXTY_DAYS"
    /// More than 60 days
    case moreThan60Days = "MORE_THAN_SIXTY_DAYS"
}
