//
//  Encodable+Extensions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

extension Encodable {
    /// Instance method for a single Encodable object
    func jsonString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let jsonData = try? encoder.encode(self) {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return "Error encoding data: \(self)"
    }
}
