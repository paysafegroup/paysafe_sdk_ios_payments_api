//
//  SDKInfo.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Information regarding the Cardinal version used in this module
struct SDKInfo: Codable {
    /// Full version: 2.2.5-7
    static let currentVersion = SDKInfo(version: "2.2.5", type: "IOS")
    /// Version
    private let version: String
    /// Type
    private let type: String
}
