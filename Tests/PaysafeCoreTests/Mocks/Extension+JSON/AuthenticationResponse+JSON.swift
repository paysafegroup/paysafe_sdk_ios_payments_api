//
//  AuthenticationResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore

extension AuthenticationResponse {
    static func jsonMock() -> String {
        """
        {
            "status": "PENDING",
            "sdkChallengePayload": "testChallengePayload"
        }
        """
    }
}
