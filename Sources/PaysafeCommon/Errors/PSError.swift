//
//  PSError.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSError
public struct PSError: Error {
    /// Error code
    public let errorCode: PSErrorCode
    /// Code
    public let code: Int
    /// Display message
    public let displayMessage: String
    /// Detailed message
    public let detailedMessage: String
    /// Correlation id
    public let correlationId: String
    /// Common server error message
    static let serverCommunicationErrorMessage = "Error communicating with server."

    /// - Parameters:
    ///   - errorCode: PSErrorCode
    ///   - correlationId: Correlation id
    ///   - code: Code
    ///   - detailedMessage: Detailed error message
    init(
        errorCode: PSErrorCode,
        correlationId: String,
        code: Int,
        detailedMessage: String
    ) {
        self.errorCode = errorCode
        self.correlationId = correlationId
        self.code = code
        self.detailedMessage = detailedMessage
        displayMessage = "There was an error (\(code)), please contact our support."
    }
}
