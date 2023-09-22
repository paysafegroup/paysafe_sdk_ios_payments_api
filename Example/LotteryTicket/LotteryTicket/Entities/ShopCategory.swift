//
//  ShopCategory.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

/// Available shop categories
enum ShopCategory: Int, CaseIterable {
    /// This case represents the `Lottery Tickets` category
    case lotteryTickets
    /// This case represents the `Raffle Draws` category
    case raffleDraws
    /// This case represents the `Bingo Games` category
    case bingoGames
    /// This case represents the `Trivia & Quizes` category
    case triviaQuizes

    /// Shop category title
    var title: String {
        switch self {
        case .lotteryTickets:
            return "Lottery Tickets"
        case .raffleDraws:
            return "Raffle Draws"
        case .bingoGames:
            return "Bingo Games"
        case .triviaQuizes:
            return "Trivia & Quizes"
        }
    }

    /// Shop category icon name
    var iconName: String {
        switch self {
        case .lotteryTickets:
            return "lotteryTickets"
        case .raffleDraws:
            return "raffleDraws"
        case .bingoGames:
            return "bingoGames"
        case .triviaQuizes:
            return "triviaQuizes"
        }
    }
}
