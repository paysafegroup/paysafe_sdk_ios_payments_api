//
//  SceneDelegate.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit
import PaysafeVenmo

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        PSVenmoContext.setURLScheme(scheme: "com.paysafe.payments.MobileSDK-demo.payments")
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        PSVenmoContext.setURLContexts(contexts: URLContexts)
    }
}
