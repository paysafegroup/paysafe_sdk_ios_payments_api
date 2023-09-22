//
//  OrderItemDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// These are the details of a previously made purchase or preorder.
public struct OrderItemDetails: Encodable {
    /// Pre order item availability date
    let preOrderItemAvailabilityDate: String?
    /// Pre order purchase indicator
    let preOrderPurchaseIndicator: String?
    /// Reorder items indicator
    let reorderItemsIndicator: String?
    /// Shipping indicator
    let shippingIndicator: String?

    /// - Parameters:
    ///   - preOrderItemAvailabilityDate: Pre order item availability date
    ///   - preOrderPurchaseIndicator: Pre order purchase indicator
    ///   - reorderItemsIndicator: Reorder items indicator
    ///   - shippingIndicator: Shipping indicator
    public init(
        preOrderItemAvailabilityDate: String?,
        preOrderPurchaseIndicator: String?,
        reorderItemsIndicator: String?,
        shippingIndicator: String?
    ) {
        self.preOrderItemAvailabilityDate = preOrderItemAvailabilityDate
        self.preOrderPurchaseIndicator = preOrderPurchaseIndicator
        self.reorderItemsIndicator = reorderItemsIndicator
        self.shippingIndicator = shippingIndicator
    }

    /// OrderItemDetailsRequest
    var request: OrderItemDetailsRequest {
        OrderItemDetailsRequest(
            preOrderItemAvailabilityDate: preOrderItemAvailabilityDate,
            preOrderPurchaseIndicator: preOrderPurchaseIndicator,
            reorderItemsIndicator: reorderItemsIndicator,
            shippingIndicator: shippingIndicator
        )
    }
}
