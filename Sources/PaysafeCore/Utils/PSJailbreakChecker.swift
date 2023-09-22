//
//  PSJailbreakChecker.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// PSJailbreakChecker
enum PSJailbreakChecker {
    // Determines if the device is jailbroken by checking for jailbreak specific files.
    static func isJailbroken() -> Bool {
        FileManager.default.fileExists(atPath: "/private/var/lib/apt") ||
            FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
    }
}
