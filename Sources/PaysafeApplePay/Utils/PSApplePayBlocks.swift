//
//  PSApplePayBlocks.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit
import PaysafeCommon

/// Paysafe Apple Pay finalize block.
public typealias PSApplePayFinalizeBlock = (PKPaymentAuthorizationStatus, PSError?) -> Void
