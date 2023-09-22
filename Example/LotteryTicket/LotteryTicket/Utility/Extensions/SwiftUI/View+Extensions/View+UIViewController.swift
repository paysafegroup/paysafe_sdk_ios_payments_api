//
//  View+UIViewController.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI
import UIKit

extension View {
    var asUIViewController: UIViewController {
        UIHostingController(rootView: self)
    }
}
