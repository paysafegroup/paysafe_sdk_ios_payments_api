//
//  APIError+Custom.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Create custom APIError
public extension APIError {
    static var encodingError: APIError {
        APIError(
            error: .init(
                code: "9205",
                message: "Encoding error."
            ))
    }

    static var invalidURL: APIError {
        APIError(
            error: .init(
                code: "9168",
                message: "Error communicating with server."
            ))
    }

    static var timeoutError: APIError {
        APIError(
            error: .init(
                code: "9204",
                message: "Timeout error."
            )
        )
    }

    static var noConnectionToServer: APIError {
        APIError(
            error: .init(
                code: "9001",
                message: "No connection to server."
            )
        )
    }

    static var genericAPIError: APIError {
        APIError(
            error: .init(
                code: "9014",
                message: "Unhandled error occurred."
            )
        )
    }

    static var invalidResponse: APIError {
        APIError(
            error: .init(
                code: "9002",
                message: "Error communicating with server."
            )
        )
    }
}
