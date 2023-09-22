//
//  PSLogError.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCommon

/// PSLogError
struct PSLogError: Encodable {
    /// Code
    let code: Int
    /// Detailed message
    let detailedMessage: String
    /// Display message
    let displayMessage: String
    /// Name
    let name: String
    /// Message
    let message: String
}

extension PSError {
    func toLogError() -> PSLogError {
        PSLogError(
            code: code,
            detailedMessage: detailedMessage,
            displayMessage: displayMessage,
            name: errorCode.type.rawValue,
            message: displayMessage
        )
    }
}
