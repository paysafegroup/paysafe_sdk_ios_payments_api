//
//  UINavigationController+PopGesture.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// Enables the pop back gesture whilst the default back button is hidden in SwiftUI
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
