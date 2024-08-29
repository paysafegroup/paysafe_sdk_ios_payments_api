//
//  APIError+PaysafeCardPayments.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Map APIError to PSError
extension APIError {
    public func toPSError(
        _ correlationId: String
    ) -> PSError {
        switch error.code {
        case "5001":
            return PSError.coreInvalidCurrencyCode(correlationId)
        case "5279":
            return PSError.coreInvalidAPIKeyFormat(correlationId)
        case "9205":
            return PSError.encodingError(correlationId)
        case "9168":
            return PSError.invalidURL(correlationId)
        case "9204":
            return PSError.timeoutError(correlationId)
        case "9001":
            return PSError.noConnectionToServer(correlationId)
        case "9014":
            return PSError.genericAPIError(correlationId)
        case "9002":
            return PSError.invalidResponse(correlationId)
        default:
            return PSError.genericAPIError(
                correlationId,
                message: error.message,
                code: Int(error.code) ?? 0
            )
        }
    }
}
