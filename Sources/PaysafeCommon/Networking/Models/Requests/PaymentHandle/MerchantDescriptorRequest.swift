//
//  MerchantDescriptorRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// MerchantDescriptorResponse
struct MerchantDescriptorRequest: Encodable {
    /// Dynamic descriptor
    let dynamicDescriptor: String
    /// Phone
    let phone: String?
}
