//
//  PaysafeCore+String+Extensions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

extension String {
    var isThreeLetterCharacterString: Bool {
        PSRegexValidator.evaluate(string: self, pattern: "^[A-Z]{3}$")
    }

    var containsOnlyNumbers: Bool {
        PSRegexValidator.evaluate(string: self, pattern: "^[0-9]+$")
    }

    func fromBase64() -> String? {
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
}

// MARK: - Assertion failure messages
extension String {
    /// Uninitialized SDK assertion failure message.
    static let uninitializedSDKMessage = "Initialize PaysafeSDK using the `setup` method."
    /// Initialize SDK with valid API key assertion failure message.
    static let invalidSDKAPIKeyMessage = "Initialize PaysafeSDK with a valid API key."
    /// Unavailable environment assertion failure message.
    static let unavailableSDKEnvironment = "Paysafe production environment is unavailable for simulator or jailbroken devices."
}
