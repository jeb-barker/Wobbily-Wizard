//  Shop.swift
//  Wobbily Wizard
//
//  Created by Nick Pleva on 10/14/25.
//

import SwiftUI

struct Shop: View {
    let items = [["🍎", "Tomato"], ["🌿", "Leaf"], ["💎", ""], ["🐍", ""], ["🍔", ""], ["🍕", ""], ["🍜", ""], ["🌮", ""], ["🍣", ""], ["🥗", ""], ["💀", ""], ["🧪", ""], ["⛧", ""], ["🖤", ""], ["🕯️", ""], ["⚗️", ""]]
    
    var body: some View {
        VStack {
            
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
