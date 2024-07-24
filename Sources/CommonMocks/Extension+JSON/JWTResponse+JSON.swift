//
//  JWTResponse+JSON.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import Paysafe3DS

extension JWTResponse {
    static func jsonMock() -> String {
        """
        {
          "sdk" : {
            "version" : "version",
            "type" : "type"
          },
          "id" : "id",
          "accountId" : "accountId",
          "jwt" : "jwt",
          "card" : {
            "cardBin" : "cardBin"
          },
          "deviceFingerprintingId" : "deviceFingerprintingId"
        }
        """
    }
}
