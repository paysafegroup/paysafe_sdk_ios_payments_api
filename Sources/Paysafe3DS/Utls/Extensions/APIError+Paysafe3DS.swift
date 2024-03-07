//
//  APIError+Paysafe3DS.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
import PaysafeNetworking
#endif

/// Map APIError to PSError
extension APIError {
    func from3DStoPSError(
        _ correlationId: String
    ) -> PSError {
        switch error.code {
        case "5000", "5275", "5276", "5278", "5280", "5279":
            return PSError.threeDSInvalidApiKeyParameter(correlationId)
        case "5010":
            return PSError.threeDSInvalidCountryParameter(correlationId)
        case "5003":
            return PSError.threeDSInvalidAmount(correlationId)
        case "5001":
            return PSError.threeDSInvalidCurrencyCode(correlationId)
        case "9205":
            return PSError.threeDSEncodingError(correlationId)
        case "9168":
            return PSError.threeDSInvalidURL(correlationId)
        case "9204":
            return PSError.timeoutError(correlationId)
        case "9001":
            return PSError.noConnectionToServer(correlationId)
        case "9014":
            return PSError.genericAPIError(correlationId)
        case "9002":
            return PSError.threeDSInvalidResponse(correlationId)
        default:
            return PSError.genericAPIError(
                correlationId,
                message: error.message,
                code: Int(error.code) ?? 0
            )
        }
    }
}
