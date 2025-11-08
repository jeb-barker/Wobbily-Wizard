//  Shop.swift
//  Wobbily Wizard
//
//  Created by Nick Pleva on 10/14/25.
//

import SwiftUI

struct Shop: View {
    @EnvironmentObject var itemData: ItemData
    @State private var balance = 1234567 // Max balance will be set to 9,999,999 later
    var body: some View {
        VStack {
            if (balance > 9999999) {
                Text("🤑🤑🤑🤑")
                .offset(x: -104, y: -239)
                .font(.custom("Noteworthy", size: 17))
            } else {
                Text("💎:\(balance)")
                .offset(x: -104, y: -239)
                .font(.custom("Noteworthy", size: 17))
            }
            VStack(alignment: .leading, spacing: 15) {
                ForEach(0..<itemData.currentShop.count, id: \.self) { rowIndex in
                    let item = itemData.currentShop[rowIndex]
                    HStack(spacing: 40) {
                        // Icon
                        Button(action: {
                            balance = balance - item.2
                        }) {
                            Text(item.0)
                        }.offset(x: -90, y: 205)
                        // Name
                        Text(item.1).offset(x: -90, y: 205)
                        // Cost
                        Text("💎 \(item.2)")
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
