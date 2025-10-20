//  Shop.swift
//  Wobbily Wizard
//
//  Created by Nick Pleva on 10/14/25.
//

import SwiftUI

struct Shop: View {
    let items = [["🍎", "Tomato"], ["🌿", "Leaf"], ["💎", ""], ["🐍", ""], ["🍔", ""], ["🍕", ""], ["🍜", ""], ["🌮", ""], ["🍣", ""], ["🥗", ""], ["💀", ""], ["🧪", ""], ["⛧", ""], ["🖤", ""], ["🕯️", ""], ["⚗️", ""]]
    let balance = 1234567 // Max balance will be set to 9,999,999 later
    var body: some View {
        VStack {
            Text("$\(balance)")
                .offset(x: -104, y: -320)
                .font(.custom("Noteworthy", size: 17))
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
