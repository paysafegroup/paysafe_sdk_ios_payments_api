//
//  MerchantDescriptorResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// MerchantDescriptorResponse
struct MerchantDescriptorResponse: Decodable {
    /// Dynamic descriptor
    let dynamicDescriptor: String
    /// Phone
    let phone: String?
}
