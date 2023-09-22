//
//  DispatchQueue+Async.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

func asyncMain(execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.async { work() }
}

func asyncMainDelayed(with seconds: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { work() }
}
