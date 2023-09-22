//
//  SDKConfiguration.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public enum SDKConfiguration {
    /// The current version of this module
    ///
    /// - Note: The current version of this module is defined as a static string.
    /// For dynamic frameworks, we can use methods to fetch the version string from `CFBundleShortVersionString` in the bundle.
    /// However, for statically linked SDKs or libraries, they are integrated directly into the app binary, losing their separate bundle distinction.
    /// In such cases, fetching the `CFBundleShortVersionString` would retrieve the app's version, not the SDK's.
    public static let sdkVersion = "1.0.0"
}
