//
//  InitialUsageRangeRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// InitialUsageRangeRequest
enum InitialUsageRangeRequest: String, Encodable {
    /// Current transaction
    case currentTransaction = "CURRENT_TRANSACTION"
    /// Less than 30 days
    case lessThan30Days = "LESS_THAN_THIRTY_DAYS"
    /// From 30 to 60 days
    case from30To60Days = "THIRTY_TO_SIXTY_DAYS"
    /// More than 60 days
    case moreThan60Days = "MORE_THAN_SIXTY_DAYS"
}
