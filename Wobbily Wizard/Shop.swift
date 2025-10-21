//  Shop.swift
//  Wobbily Wizard
//
//  Created by Nick Pleva on 10/14/25.
//

import SwiftUI

struct Shop: View {
    @EnvironmentObject var shopData: ShopData
    let balance = 1234567 // Max balance will be set to 9,999,999 later
    var body: some View {
        VStack {
            Text("$\(balance)")
                .offset(x: -104, y: -239)
                .font(.custom("Noteworthy", size: 17))
            VStack(alignment: .leading, spacing: 15) {
                ForEach(0..<shopData.currentShop.count, id: \.self) { rowIndex in
                    let item = shopData.currentShop[rowIndex]
                    HStack(spacing: 40) {
                        Text(item.0).offset(x: -90, y: 205)
                        Text(item.1).offset(x: -90, y: 205)
                        //Text("\(item.2)").offset(x: -90, y: 205)
                    }
                }
            }
            //let item = shopData.currentShop[3]
            //Text("\(item.0) | \(item.1) | \(item.2)")
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
