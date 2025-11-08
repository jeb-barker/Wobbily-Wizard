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
    @StateObject private var fightModel : FightModel = FightModel()
    @EnvironmentObject private var stepCountModel : StepCountViewModel
    
    var body: some View {
        if fightModel.isFightOver {
            VStack {
                FightStatusBarView()
                    .environmentObject(fightModel)
                    .padding(10)
                    .frame(width: UIScreen.screenWidth,
                       alignment: .bottom)
                    .background(Color.brown)
                
                Spacer()
                
                //Fight Over Message:
                if fightModel.isPlayerWinner {
                    Text("The Evil Wizard Was Defeated!")
                        .padding(8)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                        .background(.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                else {
                    Text("You've Been Blasted Away by the Evil Wizard.")
                        .padding(8)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                        .background(.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer()
                
                PotionBarView()
                    .environmentObject(fightModel)
                    .frame(width: UIScreen.screenWidth, alignment: .bottom)
                    .background(Color.brown)
            }
            .navigationBarBackButtonHidden(false)
            .onDisappear {
                stepCountModel.fightOver()
            }
        }
        else {
            VStack {
                FightStatusBarView()
                    .environmentObject(fightModel)
                    .padding(10)
                    .frame(width: UIScreen.screenWidth,
                       alignment: .bottom)
                    .background(Color.brown)
                //Evil Wizard (temp image)
                Image("evil_wizard")
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/4)
                    .scaleEffect(1.5)
                Divider()
                //Temp
                
                //Fight Scene
                SpriteView(scene: FightScreenScene(), options: [.allowsTransparency,]).ignoresSafeArea()
                
                Spacer()
                //Potion Bar
                PotionBarView()
                    .environmentObject(fightModel)
                    .frame(width: UIScreen.screenWidth, alignment: .bottom)
                    .background(Color.brown)
            }
            .navigationBarBackButtonHidden(true)
        }
        
        
    }
}



struct HealthProgressView: View {
    @EnvironmentObject var fightModel : FightModel;

    var body: some View {
        VStack {
            ProgressView(value: fightModel.enemyHealth, total: 100.0).progressViewStyle(HealthProgressStyle())
        }
    }
}

struct HealthProgressStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            let barHeight: CGFloat = 25
            GeometryReader {
                geometry in
                let totalWidth = geometry.size.width
                //Outer Rectangle for progress bar
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: barHeight)
                    .foregroundColor(.gray.opacity(0.3))
                
                //Inner Rectangle for progress bar
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * totalWidth, height: barHeight)
                    .foregroundColor(.red)
            }.frame(height: barHeight) // have to limit height bc GeometryReader takes up all available space
        }
    }
}

struct PotionBarView: View {
    @EnvironmentObject var fightModel : FightModel;

    var body: some View {
        HStack {
            Button {
                if !fightModel.isFightOver {
                    fightModel.usePotion(.red)
                }
            } label: {
                Image("potion_red").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
            }
            Button {
                if !fightModel.isFightOver {
                    fightModel.usePotion(.green)
                }
            } label: {
                Image("potion_green").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
            }
            Button {
                if !fightModel.isFightOver {
                    fightModel.usePotion(.yellow)
                }
            } label: {
                Image("potion_yellow").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
            }
            Button {
                if !fightModel.isFightOver {
                    fightModel.usePotion(.purple)
                }
            } label: {
                Image("potion_purple").frame(width: UIScreen.screenWidth / 6).scaleEffect(2).padding(8)
            }
        }

    }
}

struct FightStatusBarView: View {
    @EnvironmentObject var fightModel : FightModel;

    var body: some View {
        HStack {
            //Status Effects Bar (just show icons...)
            Text("Weak to: \(fightModel.enemyWeakness.description)").frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(fightModel.enemyWeakness.color)//TODO
            //Turns remaining
            Text("\(fightModel.turnsRemaining)").frame(maxWidth: .infinity, alignment: .center)
            HealthProgressView().environmentObject(fightModel).frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    Fight()
}
