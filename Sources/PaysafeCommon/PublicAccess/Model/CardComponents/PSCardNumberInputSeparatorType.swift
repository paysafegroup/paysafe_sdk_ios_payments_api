//
//  PSCardNumberInputSeparatorType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PSCardNumberInputSeparatorType
public enum PSCardNumberInputSeparatorType {
    /// Whitespace separator
    case whitespace
    /// No separator
    case none
    /// Dash separator
    case dash
    /// Slash separator
    case slash

    /// Separator string
    public var separator: String {
        switch self {
        case .whitespace:
            return " "
        case .none:
            return ""
        case .dash:
            return "-"
        case .slash:
            return "/"
        }
    }
}
