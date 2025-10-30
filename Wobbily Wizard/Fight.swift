//
//  Fight.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/29/25.
//

import SwiftUI
import SpriteKit

struct Fight: View {
    @State private var isFightComplete : Bool = false
    
    var body: some View {
        VStack {
            /*
                Status Bars
                    Status Effects
                    Turns Remaining
                    Health Bar
                Evil Wizard Animation
                Drawable Area
                    - SpriteKit Scene
                    - User must draw gestures within this area
                Potion Selection
                    - Greyed out during animations
                    - Data comes from other model?
             */
            HStack {
                //Status Effects Bar (just show icons...)
                Text("Status Effects").frame(maxWidth: .infinity, alignment: .leading)
                //Turns remaining
                Text("10").frame(maxWidth: .infinity, alignment: .center)
                Text("progress").frame(maxWidth: .infinity, alignment: .trailing)
            }.padding(10)
            .frame(width: UIScreen.screenWidth,
                   alignment: .bottom)
            .background(Color.brown)
            //Evil Wizard (temp image)
            Image("evil_wizard")
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/4)
                .scaleEffect(1.5)
            Divider()
            //Temp
            
            Text("ouchie")
            Button("Done?", action: {isFightComplete = !isFightComplete})
            
            Spacer()
            HStack {
                Button {
                    // TODO
                } label: {
                    Image("potion_red").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
                }
                Button {
                    // TODO
                } label: {
                    Image("potion_green").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
                }
                Button {
                    // TODO
                } label: {
                    Image("potion_yellow").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
                }
                Button {
                    // TODO
                } label: {
                    Image("potion_purple").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
                }
            }.frame(width: UIScreen.screenWidth, alignment: .bottom).background(Color.brown)
        }
        .navigationBarBackButtonHidden(isFightComplete)
        
    }
}

#Preview {
    Fight()
}
