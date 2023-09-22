//
//  ReturnAction.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Return action
enum ReturnAction: String, Codable {
    /// On completed
    case onCompleted = "on_completed"
    /// On failed
    case onFailed = "on_failed"
    /// On cancelled
    case onCancelled = "on_cancelled"
    /// Redirect payment
    case redirectPayment = "redirect_payment"
    /// Default action
    case defaultAction = "default"
}
