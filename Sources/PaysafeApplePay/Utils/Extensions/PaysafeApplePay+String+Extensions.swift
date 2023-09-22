//
//  PaysafeApplePay+String+Extensions.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

extension String {
    /// Returns nil if the string is empty.
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
