//
//  Home.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI
import HealthKit
import CoreMotion

struct Home: View {
    @State private var total : Double = 0.1
    @StateObject private var stepCountModel = StepCountViewModel();
    
    var body: some View {
        VStack {
            // set total equal to the percentage of steps taken towards the goal.
            LinearProgressView().frame(alignment: .top).environmentObject(stepCountModel).task {
                
            }
            Text("Steps: \(Int(stepCountModel.steps)) + \(Int(stepCountModel.pedometerSteps))")
            Spacer()
            CircleRotation().frame(alignment: .bottom)
        }.task {
            await stepCountModel.requestAuth()
            //start counting steps
            stepCountModel.fetchStepsInterval()
        }
        .padding()
    }
}


//temporary rotating globe. I would like to replace this with an image that we draw
struct CircleRotation: View {
    @State private var degrees: Double = 0;

    var body: some View {
        Image(systemName: "globe.americas")
            .resizable()
            .frame(width: 200, height: 200)
            .foregroundColor(.blue)
            .rotationEffect(Angle(degrees: degrees)) // Apply rotation effect
            .animation(Animation.linear(duration: 15).repeatForever(autoreverses: false), value: degrees) // Apply animation
            .onAppear {
                degrees = 360
            }
    }
}

struct LinearProgressView: View {
    @EnvironmentObject var stepCountModel : StepCountViewModel;

    var body: some View {
        VStack {
            ProgressView(value: (stepCountModel.steps + stepCountModel.pedometerSteps), total: stepCountModel.stepGoal)
                .progressViewStyle(PurplePotionProgressViewStyle()).environmentObject(stepCountModel)
            Button("More") {
                Task{
                    try?
                    await stepCountModel.fetchCumulativeSteps()
                }
            }
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
}
