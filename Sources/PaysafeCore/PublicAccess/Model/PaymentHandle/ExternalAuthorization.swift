//
//  ExternalAuthorization.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Specify how any external authorization windows will be opened (3DS etc.)
public enum ExternalAuthorization: String, Encodable {
    /// In frame
    case iframe = "IFRAME"
    /// New tab
    case newTab = "NEW_TAB"
}
