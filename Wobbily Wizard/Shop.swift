//  Shop.swift
//  Wobbily Wizard
//
//  Created by Nick Pleva on 10/14/25.
//

import SwiftUI

struct Shop: View {
    @EnvironmentObject var itemData: ItemData
    @EnvironmentObject var playerData: PlayerData
    
    var body: some View {
        VStack {
            if (playerData.balance > 999999) {
                Text("🤑🤑🤑🤑")
                .offset(x: -104, y: -239)
                .font(.custom("Noteworthy", size: 17))
            } else {
                Text("💎 \(playerData.balance)")
                .offset(x: -104, y: -239)
                .font(.custom("Noteworthy", size: 17))
            }
            VStack(alignment: .leading, spacing: 15) {
                ForEach(0..<itemData.currentShop.count, id: \.self) { rowIndex in
                    let item = itemData.currentShop[rowIndex]
                    HStack(spacing: 15) {
                        // Icon
                        Button(action: {
                            if (playerData.balance >= item.2) {
                                playerData.balance -= item.2
                                for i in playerData.inventory {
                                    if (i.name == item.1) {
                                        i.amount = i.amount + 1
                                    }
                                }
                                playerData.save()
                                print(playerData.printPretty())
                            }
                        }) {
                            Text(item.0)
                        }.offset(x: -45, y: 205)
                        // Name
                        Text(item.1)
                            .frame(width: 120, alignment: .leading)
                            .offset(x: -45, y: 205)
                        // Cost
                        Text("💎 \(item.2)").offset(x: -45, y: 205)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Image("Shop_Wizard_Back")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.25)
                .ignoresSafeArea()
        )
    }
}
