//
//  InventoryPotion.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/8/25.
//

class InventoryPotion: Codable, Equatable {
    public var name : String
    public var amount : Int
    public var potionType : PotionType
    
    init(_ name : String, _ amount : Int) {
        self.name = name
        self.amount = amount
        
        switch name {
        case "fire":
            self.potionType = .red
        case "electric":
            self.potionType = .yellow
        case "poison":
            self.potionType = .green
        case "ice":
            self.potionType = .purple
        case _:
            self.potionType = .red
            print("incorrect potion name")
        }
    }
    
    static func == (lhs: InventoryPotion, rhs: InventoryPotion) -> Bool {
        return lhs.name == rhs.name && lhs.amount == rhs.amount
    }
}
