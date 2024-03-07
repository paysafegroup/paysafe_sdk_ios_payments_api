//
//  PSApplePayBlocks.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

/// Paysafe Apple Pay finalize block.
public typealias PSApplePayFinalizeBlock = (PKPaymentAuthorizationStatus, PSError?) -> Void
