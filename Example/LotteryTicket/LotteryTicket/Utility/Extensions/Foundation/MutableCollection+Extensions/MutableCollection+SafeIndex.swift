//
//  MutableCollection+SafeIndex.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

extension MutableCollection {
    subscript(safeIndex index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            if let newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}
