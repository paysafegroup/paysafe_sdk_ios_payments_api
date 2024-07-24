//
//  ChangedRange.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// This is the length of time between the most recent change to the cardholder’s account information and the API call of the current transaction.
public enum ChangedRange: String, Encodable {
    /// During transaction
    case duringTransaction = "DURING_TRANSACTION"
    /// Less than 30 days
    case lessThan30Days = "LESS_THAN_THIRTY_DAYS"
    /// From 30 to 60 days
    case from30To60Days = "THIRTY_TO_SIXTY_DAYS"
    /// More than 60 days
    case moreThan60Days = "MORE_THAN_SIXTY_DAYS"

    /// ChangedRangeRequest
    var request: ChangedRangeRequest {
        switch self {
        case .duringTransaction:
            return .duringTransaction
        case .lessThan30Days:
            return .lessThan30Days
        case .from30To60Days:
            return .from30To60Days
        case .moreThan60Days:
            return .moreThan60Days
        }
    }
}
