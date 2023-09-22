//
//  PSPayPalRenderType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// PayPalRenderType
public enum PSPayPalRenderType {
    /// PayPal native render type using clientId and environment
    case native(clientId: String, environment: PSPayPalEnvironment)
    /// PayPal web render type
    case web
}
