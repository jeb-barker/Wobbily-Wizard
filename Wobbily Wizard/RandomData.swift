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

class ItemData: ObservableObject {
    // (componant, name, price, type)
    let allItems = [("🌻", "Sun Flower", 2, "fire"), ("🌶️", "Hot Pepper", 4, "fire"), ("🌡️", "Thermometer", 6, "fire"), ("🧨", "Fire Cracker", 8, "fire"),
                    ("🔌", "Cable", 2, "electric"), ("🔋", "Battery", 4, "electric"), ("⚡", "Lightning", 6, "electric"), ("📱", "Device", 8, "electric"),
                    ("🐍", "Snake", 2, "poison"), ("🧪", "Vile", 4, "poison"), ("💀", "Skull", 6, "poison"), ("☢️", "Nuclear Waste", 8, "poison"),
                    ("🧊", "Ice Cube", 2, "ice"), ("🍨", "Ice Cream", 4, "ice"), ("🥶", "Frozen Fred", 6, "ice"), ("🐧", "Penguin", 8, "ice")]
    
    @Published var currentShop: [(component: String, name: String, cost: Int, type: String)]

    // Initializes time interval and first indexes
    private let interval: TimeInterval = 3600
    private var i1 = 0, i2 = 1, i3 = 2, i4 = 3, i5 = 4

    init() {
        let now = Date()
        let lastGen = UserDefaults.standard.object(forKey: "shopLastGenTime") as? Date ?? .distantPast

        // Check if it’s been an hour
        if now.timeIntervalSince(lastGen) >= interval {
            // Generate new random indexes
            let newIndexes = Array(0..<allItems.count).shuffled().prefix(5)
            let indexes = Array(newIndexes)

            i1 = indexes[0]
            i2 = indexes[1]
            i3 = indexes[2]
            i4 = indexes[3]
            i5 = indexes[4]

            // Save the new indexes and the generation time
            UserDefaults.standard.set(now, forKey: "shopLastGenTime")
            UserDefaults.standard.set(indexes, forKey: "shopIndexes")
        } else {
            // Use previously saved indexes if available
            if let saved = UserDefaults.standard.array(forKey: "shopIndexes") as? [Int], saved.count == 5 {
                i1 = saved[0]
                i2 = saved[1]
                i3 = saved[2]
                i4 = saved[3]
                i5 = saved[4]
            }
        }

        // Update the shop items
        currentShop = [allItems[i1], allItems[i2], allItems[i3], allItems[i4], allItems[i5]]
    }
}
