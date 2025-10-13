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
            LinearProgressView(progress: stepCountModel.steps / 300, stepCountModel: stepCountModel).frame(alignment: .top)
            Text("\(stepCountModel.steps)")
            Spacer()
            CircleRotation().frame(alignment: .bottom)
        }.task {
            //stepCountModel.startPedometerUpdates()
            await stepCountModel.requestAuth()
        }
        .padding()
    }
}



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
    @State var progress : Double;
    @StateObject var stepCountModel : StepCountViewModel;

    var body: some View {
        VStack {
            ProgressView(value: stepCountModel.steps == -1 ? 0 : stepCountModel.steps, total: 300)
                .progressViewStyle(PurplePotionProgressViewStyle())
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
            }.frame(height: barHeight) // have to limit height bc GeometryReader takes up all available space
        }
    }
}

//class StepCountViewModel: ObservableObject {
//    private let pedometer = CMPedometer()
//    @Published var steps: Double = 0
//
//    func startPedometerUpdates() {
//        guard CMPedometer.isPedometerEventTrackingAvailable() else {
//            print("Pedometer event tracking not available.")
//            return
//        }
//
//        pedometer.startUpdates(from: Date()) { [weak self] (pedometerData, error) in
//            DispatchQueue.main.async {
//                if let pedometerData = pedometerData {
//                    self?.steps = pedometerData.numberOfSteps.doubleValue
//                } else if let error = error {
//                    print("Pedometer error: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func stopPedometerUpdates() {
//        pedometer.stopUpdates()
//    }
//}

//extend date to quickly zero seconds out
extension Date {
    var zeroSeconds: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)
    }
}

enum StepCounterError: Error {
    case couldNotFetchHealthStore
}

// View Model Representing the amount of steps taken
final class StepCountViewModel: ObservableObject {

    @Published var healthStore: HKHealthStore?
    @Published var error: Error?
    @Published var steps: Double = -1
    @Published var startTime : Date = Date.now
    
    init() {
        startTime = Date()
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            error = StepCounterError.couldNotFetchHealthStore
        }
    }
    
    // Async function to request step count from HK
    func requestAuth() async {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let healthStore else { return }
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [stepCountType])
        }
        catch {
            self.error = error
        }
    }
    
    // function to get steps from time that the view model was initialized
    func fetchCumulativeSteps() async throws {
        // make sure healthStore is initialized
        guard let healthStore else { return }

        let startDate = startTime.addingTimeInterval(TimeInterval(-1))
        let healthStepType = HKQuantityType(.stepCount)
        // Sample between the last time that this function was called and now.
        let sampleDateRange = HKQuery.predicateForSamples(withStart: startDate, end: Date.now.zeroSeconds?.addingTimeInterval(TimeInterval(60)))
        // build the argument that the query expects
        let sample = HKSamplePredicate.quantitySample(type: healthStepType, predicate: sampleDateRange)
        
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: sample, options: .mostRecent, anchorDate: Date(), intervalComponents: DateComponents(day:1))

        let stepsData = try await stepsQuery.result(for: healthStore)
        
        // sum the number of steps in each time period and store in the published steps variable
        stepsData.enumerateStatistics(from: startDate.zeroSeconds?.addingTimeInterval(TimeInterval(-1)) ?? Date.now, to: Date.now.zeroSeconds?.addingTimeInterval(TimeInterval(60)) ?? Date.now) {
            statistics, pointer in
            let stepCount = statistics.sumQuantity()?.doubleValue(for: .count())
            DispatchQueue.main.async {
                if let stepCount, stepCount > 0 {
                    self.steps += stepCount
                    self.startTime = Date.now.zeroSeconds?.addingTimeInterval(TimeInterval(60)) ?? Date.now.zeroSeconds!
                    print("\(stepCount) from \(startDate.zeroSeconds!.addingTimeInterval(TimeInterval(-1))) to \(Date.now.zeroSeconds!.addingTimeInterval(TimeInterval(60)))")
                }
            }
        }
    }
}

#Preview {
    Home()
}
