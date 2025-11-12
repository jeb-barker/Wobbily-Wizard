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
    @StateObject private var fightModel : FightModel
    
    @EnvironmentObject private var playerData : PlayerData
    @EnvironmentObject private var stepCountModel : StepCountViewModel
    
    private let tauntScene : EvilWizardFightScene
    
    init(_ playerData : PlayerData) {
        _fightModel = StateObject(wrappedValue: FightModel(playerModel: playerData))
        
        tauntScene = EvilWizardFightScene(size: CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight * (1/3)))
        
    }
    
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
                    .environmentObject(playerData)
                    .frame(width: UIScreen.screenWidth, alignment: .bottom)
                    .background(Color.brown)
            }
            .navigationBarBackButtonHidden(false)
            .onDisappear {
                stepCountModel.fightOver(didPlayerWin: self.fightModel.isPlayerWinner)
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
                //Evil Wizard
                SpriteView(scene: tauntScene, options: [.allowsTransparency])
                    .frame(width: UIScreen.screenWidth,
                           height: UIScreen.screenHeight * (1/3),
                           alignment: .bottom)
                Divider()
                //Temp
                
                ZStack {
                    //Fight Scene
                    SpriteView(scene: FightScreenScene(fightModel: fightModel, size: CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight/3)), options: [.allowsTransparency,]).ignoresSafeArea().border(.black)
                    VStack {
                        HStack {
                            Spacer()
                            Button("Pass") {
                                self.fightModel.endTurn()
                            }
                            .frame(alignment: .bottom)
                            .padding(10)
                            .buttonStyle(.borderedProminent)
                            
                        }
                        .padding(10)
                        Spacer()
                    }
                    
                    
                }
                
                
                Spacer()
                //Potion Bar
                PotionBarView()
                    .environmentObject(fightModel)
                    .environmentObject(playerData)
                    .frame(width: UIScreen.screenWidth, alignment: .bottom)
                    .background(Color.brown)
            }
            .navigationBarBackButtonHidden(true)
            .task {
                self.fightModel.wizardTauntScene = tauntScene
            }
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
    @EnvironmentObject var fightModel : FightModel
    @EnvironmentObject var playerData : PlayerData

    var body: some View {
        HStack {
            ForEach(playerData.potions, id: \.potionType)
            {
                potion in
                
                Button {
                    //potions can only be used if the fight isn't over and the player isn't 'casting'
                    if !fightModel.isFightOver && !fightModel.isCasting {
                        fightModel.usePotion(potion.potionType)
                    }
                } label: {
                    ZStack {
                        Image("potion_\(potion.potionType.rawString)")
                                .frame(width: UIScreen.screenWidth / 6)
                                .scaleEffect(2)
                                .padding(8)
                        
                        Text("x\(potion.amount)")
                            .frame(alignment: .bottomTrailing)
                            .offset(x:40, y:40)
                            .padding(8)
                            .foregroundColor(.black)
                    }
                    
                }
            }
        }.offset(x:-10)

    }
}

struct FightStatusBarView: View {
    @EnvironmentObject var fightModel : FightModel;

    var body: some View {
        HStack {
            //Status Effects Bar (just show icons...)
            Text("Weaness:\n \(fightModel.enemyWeakness.description.capitalized)").frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(fightModel.enemyWeakness.color)//TODO
                .font(.title)
            //Turns remaining
            Text("\(fightModel.turnsRemaining)").frame(maxWidth: .infinity, alignment: .center)
            HealthProgressView().environmentObject(fightModel).frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    Fight(PlayerData())
        .environmentObject(PlayerData())
        .environmentObject(StepCountViewModel())
}
