//
//  AuthenticationResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments

extension AuthenticationResponse {
    public static func jsonMock() -> String {
        """
        {
            "status": "PENDING",
            "sdkChallengePayload": "testChallengePayload"
        }
        """
    }
}
