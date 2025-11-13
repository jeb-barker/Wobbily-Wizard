//
//  InventoryItem.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/8/25.
//

class InventoryItem: Codable, Equatable {
    
    public var name : String
    public var amount : Int
    
    init(_ name : String, _ amount : Int) {
        self.name = name
        self.amount = amount
    }
    
    static func == (lhs: InventoryItem, rhs: InventoryItem) -> Bool {
        return lhs.name == rhs.name && lhs.amount == rhs.amount
    }
}
