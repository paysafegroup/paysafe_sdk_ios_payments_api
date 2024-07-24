//
//  PSCoreBlocks.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

/// Paysafe card field input event block.
public typealias PSCardFieldInputEventBlock = (PSCardFieldInputEvent) -> Void
/// Paysafe card form initialize block.
public typealias PSCardFormInitializeBlock = (Result<PSCardForm, PSError>) -> Void
