//
//  RenderType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// List of all the render types that the device supports for displaying specific challenge user interfaces within the SDK
public enum RenderType: Encodable {
    /// Native
    case native
    /// Html
    case html
    /// Native and html
    case both
}
