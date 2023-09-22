//
//  ShopCategoryDetailViewModel.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import SwiftUI

final class ShopCategoryDetailViewModel: ObservableObject {
    @Published private(set) var category: ShopCategory
    @Published var items: [ShopItem] = []
    @Published var selectedItem: ShopItem?

    private var isFirstLaunch = true
    private var cancellables = Set<AnyCancellable>()

    init(category: ShopCategory) {
        self.category = category
        subscribeToSelectedItem()
    }

    func onAppear() {
        fetchItemsIfNeeded()
    }

    func select(item: ShopItem) {
        selectedItem = item
    }

    func toggleFavourite(for item: Binding<ShopItem>) {
        item.wrappedValue.favourite.toggle()
    }

    private func subscribeToSelectedItem() {
        $selectedItem
            .compactMap { $0 }
            .sink { [weak self] selectedItem in
                guard let self, let index = items.firstIndex(where: { $0.id == selectedItem.id }) else { return }
                items[safeIndex: index] = selectedItem
            }
            .store(in: &cancellables)
    }

    private func fetchItemsIfNeeded() {
        guard isFirstLaunch else { return }
        isFirstLaunch = false
        switch category {
        case .lotteryTickets:
            items = [
                ShopItem(
                    id: 0,
                    title: "Draw Games",
                    description: "Draw Games offer an exhilarating opportunity to test your luck and win big by selecting a set of numbers for a chance to match those drawn in the upcoming game. With each ticket, you hold the potential to unlock a jackpot that could turn your dreams into reality.",
                    price: 0.99,
                    date: Date(timeIntervalSince1970: 1_693_224_000),
                    iconName: "calendar",
                    favourite: true,
                    newEntry: true,
                    availableQuantity: 10
                ),
                ShopItem(
                    id: 1,
                    title: "Scratch-Off",
                    description: "",
                    price: 0.99,
                    date: Date(timeIntervalSince1970: 1_693_224_000),
                    iconName: "cheque",
                    favourite: false,
                    newEntry: true,
                    availableQuantity: 10
                ),
                ShopItem(
                    id: 2,
                    title: "Instant Win",
                    description: "",
                    price: 0.99,
                    date: Date(timeIntervalSince1970: 1_693_224_000),
                    iconName: "bankNote",
                    favourite: false,
                    newEntry: false,
                    availableQuantity: 10
                ),
                ShopItem(
                    id: 3,
                    title: "Raffles",
                    description: "",
                    price: 0.99,
                    date: Date(timeIntervalSince1970: 1_693_224_000),
                    iconName: "car",
                    favourite: false,
                    newEntry: false,
                    availableQuantity: 10
                ),
                ShopItem(
                    id: 4,
                    title: "Lucky Wheel",
                    description: "",
                    price: 0.99,
                    date: Date(timeIntervalSince1970: 1_693_224_000),
                    iconName: "wheelFortune",
                    favourite: false,
                    newEntry: false,
                    availableQuantity: 10
                ),
                ShopItem(
                    id: 5,
                    title: "Treasure Hunt",
                    description: "",
                    price: 0.99,
                    date: Date(timeIntervalSince1970: 1_693_224_000),
                    iconName: "crown",
                    favourite: false,
                    newEntry: false,
                    availableQuantity: 10
                )
            ]
        case .raffleDraws:
            break
        case .bingoGames:
            break
        case .triviaQuizes:
            break
        }
    }
}
