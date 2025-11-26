//
//  Home.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI
import HealthKit
import CoreMotion
import SpriteKit

struct Home: View {
    @State private var total : Double = 0.1
    @EnvironmentObject private var stepCountModel : StepCountViewModel
    
    @EnvironmentObject private var playerData : PlayerData
    
    private let globeSize = UIScreen.main.bounds.width * 1.5
    
    var body: some View {
        NavigationStack {
            ZStack {
                //Put the Background Image in:
                Image("home_background").resizable().scaledToFill().ignoresSafeArea()
                VStack {
                    
                    // set total equal to the percentage of steps taken towards the goal.
                    LinearProgressView().padding(8.0).frame(width: UIScreen.screenWidth, alignment: .top).environmentObject(stepCountModel)
//                    Text("Steps: \(Int(stepCountModel.steps))").foregroundStyle(.white)
                    // Fight button is only active if the model allows it.
                    if stepCountModel.isFinished() {
                        NavigationLink("FIGHT!") {
                            Fight(playerData).environmentObject(stepCountModel)
                        }
                    }
                    Spacer()
                    
                    // Evil Wizard sprite
                    SpriteView(scene: EvilWizardTauntScene(), options: [.allowsTransparency])
                        .frame(width: UIScreen.screenWidth,
                               height: UIScreen.screenHeight * (1/3),
                               alignment: .bottom)
                        .opacity(0.2 + stepCountModel.steps / stepCountModel.stepGoal)
                    
                    // Player and globe sprites
                    SpriteView(scene: PlayerWalkScene(), options: [.allowsTransparency])
                        .ignoresSafeArea(edges: .bottom)
                        .frame(width: UIScreen.screenWidth,
                               height: UIScreen.screenHeight * (1/3),
                               alignment: .bottom)
                        .offset(y:UIScreen.screenHeight * (1/9))
                        
                            
                }.task {
                    await stepCountModel.requestAuth()
                    //start counting steps
                    stepCountModel.startTimer()
                }
                .padding()
                .frame(maxHeight:.infinity)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: self.stepCountModel.steps) {
            oldValue, newValue in
            let newSteps = newValue - oldValue
            if newSteps >= 0 {
                // Only add gems if it would give more gems
                self.playerData.balance += Int(newSteps)
                print("added \(newSteps) gems")
            }
            
        }
    }
}


// Rotating globe image positioned so that the animated wizard is walking over it.
struct CircleRotation: View {
    @State private var degrees: Double = 0;
    private var size : Double
    
    init(_ size : Double) {
        self.size = size
    }

    var body: some View {
                // Rotate the Globe Sprite
        Image("home_globe")
                    .resizable()
                    .rotationEffect(Angle(degrees: -degrees)) // Apply rotation effect
                    .animation(Animation.linear(duration: 150).repeatForever(autoreverses: false), value: degrees) // Apply animation

                    .onAppear {
                        degrees = 360
                    }
    }
}

struct LinearProgressView: View {
    @EnvironmentObject var stepCountModel : StepCountViewModel;

    var body: some View {
        VStack {
            ProgressView(value: (stepCountModel.steps > stepCountModel.stepGoal ? stepCountModel.stepGoal : stepCountModel.steps), total: stepCountModel.stepGoal)
                .progressViewStyle(PurplePotionProgressViewStyle()).environmentObject(stepCountModel)
            Button("More") {
                Task{
                    await stepCountModel.debugSteps()
                }
            }.foregroundStyle(.white)
        }
    }
}

struct PurplePotionProgressViewStyle: ProgressViewStyle {
    @EnvironmentObject var stepCountModel : StepCountViewModel
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            let barHeight: CGFloat = 35
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
                    .foregroundColor(.purple)
                //Label / Popup
                Text("+\(stepCountModel.latestSteps)").foregroundStyle(.opacity(0.5))
                    .position(CGPoint(x: geometry.size.width/2, y: barHeight/2))
            }.frame(height: barHeight) // have to limit height bc GeometryReader takes up all available space
        }
    }
}

//extend date to quickly zero seconds out
//useful for date operations in the model
extension Date {
    var zeroSeconds: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)
    }
}

#Preview {
    Home()
        .environmentObject(StepCountViewModel())
        .environmentObject(PlayerData())
}
