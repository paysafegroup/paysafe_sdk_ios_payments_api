//
//  AppCoordinator.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// AppCoordinator
final class AppCoordinator: ObservableObject {
    /// UIWindow
    private let window: UIWindow
    /// BaseNavigationController
    private let navigationController: BaseNavigationController
    /// PaymentManager
    let paymentManager: PaymentManager

    enum Configuration {
        case SwiftUI
        case UIKit
    }

    /// - Parameters:
    ///   - window: UIWindow
    init(window: UIWindow = UIWindow()) {
        self.window = window
        navigationController = BaseNavigationController()
        paymentManager = PaymentManager()
        paymentManager.setupPaysafeSDK()
        setupWindow()
    }

    /// Setup window method
    private func setupWindow() {
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
    }

    /// Start method
    func start(configuration: Configuration = .SwiftUI) {
        switch configuration {
        case .SwiftUI:
            let mainView = MainView(selectedTab: .shop)
                .environmentObject(self)
            navigationController.viewControllers = [mainView.asUIViewController]
        case .UIKit:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            navigationController.viewControllers = [viewController]
        }
    }
}
