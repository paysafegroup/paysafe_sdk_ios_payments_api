//
//  PSCoreBlocks.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

/// Paysafe SDK setup block.
public typealias PSSDKSetupBlock = (Result<Bool, PSError>) -> Void
/// Paysafe tokenize block used in the `tokenize` method that contains a result with paymentHandleToken response as a String or an error as PSError.
public typealias PSTokenizeBlock = (Result<String, PSError>) -> Void
/// Paysafe card form update block.
public typealias PSCardFormUpdateBlock = (Bool) -> Void
/// Paysafe card brand block.
public typealias PSCardBrandBlock = (PSCardBrand) -> Void
/// Paysafe card field input event block.
public typealias PSCardFieldInputEventBlock = (PSCardFieldInputEvent) -> Void
/// Paysafe card form initialize block.
public typealias PSCardFormInitializeBlock = (Result<PSCardForm, PSError>) -> Void
/// Paysafe Apple Pay context initialize block.
public typealias PSApplePayContextInitializeBlock = (Result<PSApplePayContext, PSError>) -> Void
/// Paysafe PayPal context initialize block.
public typealias PSPayPalContextInitializeBlock = (Result<PSPayPalContext, PSError>) -> Void

/// Paysafe payment methods block used in the `getAvailablePaymentMethod` method that contains a result with a payment method or a PSError.
typealias PSPaymentMethodBlock = (Result<PaymentMethod, PSError>) -> Void
