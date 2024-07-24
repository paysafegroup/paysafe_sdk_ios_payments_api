//
//  PaysafeCore+String+Extensions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

extension String {
    public var isThreeLetterCharacterString: Bool {
        PSRegexValidator.evaluate(string: self, pattern: "^[A-Z]{3}$")
    }

    public var containsOnlyNumbers: Bool {
        PSRegexValidator.evaluate(string: self, pattern: "^[0-9]+$")
    }

    public func fromBase64() -> String? {
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
}
