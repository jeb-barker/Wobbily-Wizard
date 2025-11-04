//
//  FightModel.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/4/25.
//

import SwiftUI

// View Model Representing the amount of steps taken
final class FightModel: ObservableObject {
    
    @Published var turnsRemaining : Int = 10
    @Published var enemyHealth : Double = 100
    @Published var isPlayerTurn : Bool = true
    @Published var isFightOver : Bool = false
    @Published var isPlayerWinner : Bool = false
    
    
    init() {
        
    }
    
    // Attack the enemy
    func usePotion() {
        enemyHealth -= 20 // TODO: change based on potions
        
        // end turn
        endTurn()
    }
    
    func endTurn() {
        turnsRemaining -= 1
        if turnsRemaining < 0 {
            isFightOver = true
            // Out of turns: check who won
            if enemyHealth > 0 {
                // player didn't kill the wizard in time
                isPlayerWinner = false
            }
            else {
                isPlayerWinner = true
            }
        }
    }
    
    
    
}
