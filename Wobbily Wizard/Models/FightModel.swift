//
//  FightModel.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/4/25.
//

import SwiftUI
import Foundation

// View Model Representing the amount of steps taken
final class FightModel: ObservableObject {
    
    //game state variables
    @Published var turnsRemaining : Int = 10
    @Published var enemyHealth : Double = 100
    @Published var enemyWeakness : PotionType = .green
    
    //status variables
    @Published var isPlayerTurn : Bool = true
    @Published var isFightOver : Bool = false
    @Published var isPlayerWinner : Bool = false
    
    
    init() {
        //random seed
        srand48(time_t())
    }
    
    // Attack the enemy
    func usePotion(_ potionType : PotionType) {
        if potionType == enemyWeakness {
            enemyHealth -= 20
        }
        else {
            enemyHealth -= 5
        }
        
        // end turn
        endTurn()
    }
    
    func endTurn() {
        /* at the end of each turn:
            - decrement the turn counter
            - change the enemy weakness
         */
        turnsRemaining -= 1
        let potionChoice = PotionType(rawValue: Int(drand48() * 4))!
        print("choice: \(potionChoice.self)")
        enemyWeakness = potionChoice
        
        if turnsRemaining < 0 {
            isFightOver = true
            turnsRemaining = 0 // for display purposes on the fight screen
            // Out of turns: check who won
            if enemyHealth > 0 {
                // player didn't kill the wizard in time
                isPlayerWinner = false
            }
            else {
                isPlayerWinner = true
            }
        }
        else {
            if enemyHealth <= 0 {
                isPlayerWinner = true
                isFightOver = true
            }
        }
    }
    
    
    
}
