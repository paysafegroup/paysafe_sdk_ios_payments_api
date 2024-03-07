//
//  APIError+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeNetworking

/// Mock json data for APIError
extension APIError {
    static func jsonMock(
        code: String,
        message: String
    ) -> String {
        """
        {
            "error": {
                "code": "\(code)",
                "message": "\(message)"
            }
        }
        """
    }
}
