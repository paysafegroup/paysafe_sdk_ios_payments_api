//
//  MerchantDescriptor.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct MerchantDescriptor: Encodable {
    /// Dynamic descriptor
    public let dynamicDescriptor: String
    /// Phone
    public let phone: String?

    /// - Parameters:
    ///   - dynamicDescriptor: Dynamic descriptor
    ///   - phone: Phone
    public init(
        dynamicDescriptor: String,
        phone: String?
    ) {
        self.dynamicDescriptor = dynamicDescriptor
        self.phone = phone
    }

    /// MerchantDescriptorRequest
    var request: MerchantDescriptorRequest {
        MerchantDescriptorRequest(
            dynamicDescriptor: dynamicDescriptor,
            phone: phone
        )
    }
}
