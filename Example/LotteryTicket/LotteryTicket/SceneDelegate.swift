//
//  SceneDelegate.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
