//
//  ThreeDSClientInfo.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ThreeDSClientInfo
struct ThreeDSClientInfo: Encodable {
    /// App name
    let type: String = "IOS"
    /// Version
    let version: String

    /// - Parameters:
    ///   - version: Version
    init(version: String) {
        self.version = version
    }
}
