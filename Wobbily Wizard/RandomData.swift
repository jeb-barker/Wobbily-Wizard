//
//  AppData.swift
//  Wobbily Wizard
//
//  Created by Nick Pleva on 10/20/25.
//


class AppData: ObservableObject {
    @Published var items: [(name: String, count: Int)]
    
    init(items: [(String, Int)] = [("Sample", 1), ("Test", 2)]) {
        self.items = items
    }
}

import SwiftUI

class ShopData: ObservableObject {
    let fullShop = [("🍎", "Tomato", 1), ("🌿", "Leaf", 1), ("💎", "Gem", 1), ("🐍", "Snake", 1), ("🍔", "Burger", 1), ("🍕", "Pizza", 1), ("🍜", "Soup", 1), ("🌮", "Taco", 1), ("🍣", "Sushi", 1), ("🥗", "Salad", 1), ("💀", "Skull", 1), ("🧪", "Vile", 1), ("⛧", "Star", 1), ("🖤", "Heart", 1), ("🕯️", "Candle", 1), ("⚗️", "Orb", 1)]
    @Published var currentShop: [(component: String, name: String, cost: Int)]
    
    let i1 = 0
    let i2 = 1
    let i3 = 2
    let i4 = 3
    let i5 = 4
    
    init(currentShop: [(String, String, Int)] = []) {
            if currentShop.isEmpty {
                // Default to first 5 items from fullShop
                self.currentShop = [fullShop[i1], fullShop[i2], fullShop[i3], fullShop[i4], fullShop[i5]]
            } else {
                self.currentShop = currentShop
            }
        }
}
