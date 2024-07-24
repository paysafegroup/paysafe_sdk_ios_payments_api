//
//  PSCommonBlocks.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Paysafe empty block.
public typealias PSVoidBlock = () -> Void

/// Paysafe card form update block.
public typealias PSCardFormUpdateBlock = (Bool) -> Void
/// Paysafe card brand block.
public typealias PSCardBrandBlock = (PSCardBrand) -> Void

public typealias PSTokenizeBlock = (Result<String, PSError>) -> Void
/// Paysafe payment methods block used in the `getAvailablePaymentMethod` method that contains a result with a payment method or a PSError.
public typealias PSPaymentMethodBlock = (Result<PaymentMethod, PSError>) -> Void
