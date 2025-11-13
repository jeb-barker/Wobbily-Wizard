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
    @Published var enemyShape : [Int]? // For use in the fight scene
    
    //status variables
    @Published var isPlayerTurn : Bool = true
    @Published var isFightOver : Bool = false
    @Published var isPlayerWinner : Bool = false
    
    // Player inventory and potions
    private var playerData : PlayerData
    @Published var currentSelectedPotionType : PotionType? = nil
    
    //Casting
    private var spellTimer : Timer?
    @Published var isCasting : Bool = false
    public var wizardTauntScene: EvilWizardFightScene?
    
    
    init(playerModel playerData : PlayerData) {
        //random seed
        srand48(time_t())
        self.playerData = playerData
    }
    
    // Attack the enemy
    func usePotion(_ potionType : PotionType) {
        for potion in playerData.potions {
            //find the potion type that the player chose:
            if potion.name == potionType.description {
                // if they have one available
                if potion.amount > 0 {
                    // set the selected potion type
                    self.currentSelectedPotionType = potion.potionType
                    //remove a potion from the inventory
                    potion.amount -= 1
                    // generate a new shape (3 vertices for now)
                    generateShape(vertices: 3)
                    // Send the current shape to the tauntScene
                    if let wizardTauntScene {
                        wizardTauntScene.updateCircles(enemyShape: enemyShape ?? [])
                    }
                    // start a timer that sets isCasting to true over a 5-second interval
                    isCasting = true
                    spellTimer = Timer.scheduledTimer(
                        withTimeInterval: 5,
                        repeats: false,
                        block: {timer in
                            print("timer over")
                            self.isCasting = false
                            // end turn
                            self.endTurn()
                        }
                    )
                }
            }
        }
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
    
    func generateShape(vertices : Int) {
        enemyShape = []
        var currVert : Int = -1
        for _ in 0 ..< vertices {
            currVert = Int(drand48()*5) // random index between 0 and 4
            while currVert == enemyShape?.last {
                currVert = Int(drand48()*5) // random index between 0 and 4
            }
            enemyShape?.append(currVert)
        }
        for v in enemyShape! {
            print(v)
        }
    }
    
    func onShapeDrawn(candles : [Int]) {
        var damage = 0
        //only allow if currently casting
        if isCasting {
            if candles.count == self.enemyShape?.count {
                damage = 20
                for (index, candle) in candles.enumerated() {
                    if candle != self.enemyShape?[index] {
                        damage = 10
                    }
                }
                
                // Do potion damage
                if currentSelectedPotionType == enemyWeakness {
                    damage *= 2
                }
                enemyHealth -= Double(damage)
            }
            
            //end the casting state
            spellTimer?.invalidate()
            isCasting = false
            // end turn
            endTurn()
        }
    }
    
    
    
}
