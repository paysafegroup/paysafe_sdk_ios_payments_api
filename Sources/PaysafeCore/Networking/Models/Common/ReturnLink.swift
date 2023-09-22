//
//  ReturnLink.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ReturnLink
struct ReturnLink: Codable {
    /// Rel
    let rel: ReturnAction
    /// Href
    let href: String
    /// Method
    let method: String?
}
