//
//  PSCardInputView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
import UIKit

/// PSCardInputView
protocol PSCardInputView: PSCardFieldInputEvents {
    /// Is empty
    func isEmpty() -> Bool
    /// Whether the field contains any raw text (including invalid partial input).
    func hasText() -> Bool
    /// Is valid
    func isValid() -> Bool
    /// Reset theme
    mutating func resetTheme()
    /// Reset
    func reset()
    /// Place holder
    func getPlaceholder() -> String?
}

/// PSCardFieldInputEvents
protocol PSCardFieldInputEvents {
    /// PSCardFieldInputEventBlock
    var onEvent: PSCardFieldInputEventBlock? { get set }
}

/// PSCardFieldInputEvent
public enum PSCardFieldInputEvent {
    /// Focus event
    case focus
    /// Blur event (field lost focus)
    case blur
    /// Valid event
    case valid
    /// Invalid event
    case invalid
    /// Field value change event
    case fieldValueChange
    /// Invalid character event
    case invalidCharacter
}
