//
//  AppData.swift
//  Wobbily Wizard
//
//  Created by Nick Pleva on 10/20/25.
//


/*class AppData: ObservableObject {
    @Published var items: [(name: String, count: Int)]
    
    init(items: [(String, Int)] = [("Sample", 1), ("Test", 2)]) {
        self.items = items
    }
}*/

import SwiftUI

// Observable object with the data for the player
class playerData: ObservableObject {
    // Each item in inventory: [item, amount]
    @Published var inventory: [[Any]] = []
    // Each potion in list: [type, amount]
    @Published var potions: [[Any]] = []
    @Published var balance: Int = 0

    enum CodingKeys: String, CodingKey {
        case inventory, potions, balance
    }

    // Try and load saved data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        inventory = try container.decode([[String]].self, forKey: .inventory)
        potions = try container.decode([[String]].self, forKey: .potions)
        balance = try container.decode(Int.self, forKey: .balance)
    }

    // Encode data to be saved
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inventory, forKey: .inventory)
        try container.encode(potions, forKey: .potions)
        try container.encode(balance, forKey: .balance)
    }

    // Load data from file or create defaults
    init() {
        if let saved = PlayerData.load() {
            self.inventory = saved.inventory
            self.potions = saved.potions
            self.balance = saved.balance
        } else {
            // Default data: Player starts with 500 gems, enough ingredients to make 3 fire potions, and has 2 ice potions
            self.inventory = [["Sun Flower", "3"], ["Hot Pepper", "3"], ["Thermometer", "3"], ["Fire Cracker", "3"],
                              ["Cable", "0"], ["Battery", "0"], ["Lightning", "0"], ["Device", "0"],
                              ["Snake", "0"], ["Vile", "0"], ["Skull", "0"], ["Nuclear Waste", "0"],
                              ["Ice Cube", "0"], ["Ice Cream", "0"], ["Frozen Fred", "0"], ["Penguin", "0"]]
            self.potions = [["fire", 0], ["electric", 0], ["poison", 0], ["ice", "2"]]
            self.balance = 500
        }
    }

    // Path for saving data to device
    static private var saveURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("playerData.json")
    }

    // Saving and loading the file
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            try? encoded.write(to: Self.saveURL)
        }
    }

    // Load from device if possible
    static func load() -> PlayerData? {
        guard let data = try? Data(contentsOf: saveURL) else { return nil }
        return try? JSONDecoder().decode(PlayerData.self, from: data)
    }
}

// Observable object with the data for all componants in the game
class ItemData: ObservableObject {
    // (componant, name, price, type)
    let allItems = [("🌻", "Sun Flower", 20, "fire"), ("🌶️", "Hot Pepper", 40, "fire"), ("🌡️", "Thermometer", 60, "fire"), ("🧨", "Fire Cracker", 80, "fire"),
                    ("🔌", "Cable", 20, "electric"), ("🔋", "Battery", 40, "electric"), ("⚡", "Lightning", 60, "electric"), ("📱", "Device", 80, "electric"),
                    ("🐍", "Snake", 20, "poison"), ("🧪", "Vile", 40, "poison"), ("💀", "Skull", 60, "poison"), ("☢️", "Nuclear Waste", 80, "poison"),
                    ("🧊", "Ice Cube", 20, "ice"), ("🍨", "Ice Cream", 40, "ice"), ("🥶", "Frozen Fred", 60, "ice"), ("🐧", "Penguin", 80, "ice")]
    
    @Published var currentShop: [(component: String, name: String, cost: Int, type: String)]

    // Initializes time interval and first indexes
    private let interval: TimeInterval = 36//00
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

        // Keep refreshing
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            let newIndexes = Array(0..<self.allItems.count).shuffled().prefix(5)
            let indexes = Array(newIndexes)
            self.i1 = indexes[0]
            self.i2 = indexes[1]
            self.i3 = indexes[2]
            self.i4 = indexes[3]
            self.i5 = indexes[4]
            UserDefaults.standard.set(Date(), forKey: "shopLastGenTime")
            UserDefaults.standard.set(indexes, forKey: "shopIndexes")
            DispatchQueue.main.async {
                self.currentShop = [self.allItems[self.i1], self.allItems[self.i2],
                                    self.allItems[self.i3], self.allItems[self.i4],
                                    self.allItems[self.i5]]
            }
        }
    }
}
