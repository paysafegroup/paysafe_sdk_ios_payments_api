//
//  UIDevice+SafeArea.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        guard let window = UIApplication.shared.windows.filter(\.isKeyWindow).first else { return false }
        switch userInterfaceIdiom {
        case .phone:
            return window.safeAreaInsets.bottom > 0
        default:
            return false
        }
    }
}
