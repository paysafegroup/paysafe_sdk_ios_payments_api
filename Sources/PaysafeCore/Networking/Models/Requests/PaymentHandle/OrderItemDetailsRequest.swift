//
//  OrderItemDetailsRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// These are the details of a previously made purchase or preorder.
struct OrderItemDetailsRequest: Encodable {
    /// Pre order item availability date
    let preOrderItemAvailabilityDate: String?
    /// Pre order purchase indicator
    let preOrderPurchaseIndicator: String?
    /// Reorder items indicator
    let reorderItemsIndicator: String?
    /// Shipping indicator
    let shippingIndicator: String?
}
