//
//  StepCountViewModel.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/18/25.
//
import SwiftUI
import HealthKit
import CoreMotion

enum StepCounterError: Error {
    case couldNotFetchHealthStore
}

// View Model Representing the amount of steps taken
final class StepCountViewModel: ObservableObject {

    @Published var steps: Double = 0.0
    @Published var latestSteps : Int = 0
    @Published var stepGoal : Double = 300.0
    @Published var pedometerSteps : Double = 0
    
    private var timer : Timer? = nil
    private var stepManager : StepManager
    
    init() {
        stepManager = StepManager()
    }
    
    func requestAuth() async {
        await stepManager.requestAuth()
    }
    
    
    //Starts a timer that fetches/updates the step count every 5 seconds
    func startTimer() {
        //start the refresh timer
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
            { [weak self] timer in
                guard let self = self else { return }
                Task {
                    self.updateSteps()
                }
            }
        }
        // start the stepManager Timer
        stepManager.fetchStepsInterval()
    }
    
    func updateSteps() {
        DispatchQueue.main.async {
            //print("updating steps \(self.stepManager.getTotalSteps())")
            self.steps = self.stepManager.getTotalSteps()
            self.pedometerSteps = self.stepManager.pedometerSteps
            self.latestSteps = self.stepManager.latestSteps
        }
    }
    
}

class StepManager {
    private let pedometer = CMPedometer()

    private var healthStore: HKHealthStore?
    private var error: Error?
    //Step Variables
    private var hkSteps: Double = 0.0
    private var stepGoal : Double = 300.0
    public var latestSteps : Int = 0
    public var pedometerSteps : Double = 0 // TODO: make private after testing
    //Timing Variables
    private var startTime : Date = Date.now
    private var timer : Timer? = nil
    
    init () {
        // startTime should start as the start of the current minute
        startTime = Date().zeroSeconds!
        // Try to access HealthKit data
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            error = StepCounterError.couldNotFetchHealthStore
        }
        
        // Check for pedometer (won't be available in the simulator)
        guard CMPedometer.isPedometerEventTrackingAvailable() else {
            print("Pedometer event tracking not available.")
            return
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
    
    func restartPedometer() {
        // Ensure pedometer is available
        guard CMPedometer.isPedometerEventTrackingAvailable() else {
            print("Pedometer event tracking not available.")
            return
        }
        //reset the pedometer
        pedometer.stopUpdates()
        pedometer.startUpdates(from: Date()) { [weak self] (pedometerData, error) in
            DispatchQueue.main.async {
                if let pedometerData = pedometerData {
                    self?.pedometerSteps = pedometerData.numberOfSteps.doubleValue
                } else if let error = error {
                    print("Pedometer error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //Starts a timer that fetches/updates the step count every 60 seconds
    func fetchStepsInterval() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true)
            { [weak self] timer in
                guard let self = self else { return }
                Task {
                    try await self.fetchCumulativeSteps()
                    //Also (re)start the pedometer
                    self.restartPedometer()
                }
            }
        }
    }
    
    // Fetch steps from startTime to the start of the current minute
    func fetchCumulativeSteps() async throws {
        
        // make sure healthStore is initialized
        guard let healthStore else { return }

        let startDate = startTime.zeroSeconds!.addingTimeInterval(TimeInterval(-1))
        let endDate = Date.now.zeroSeconds!
        
        //debug
        //print("getting steps from \(startDate) to \(endDate)")
        
        // only query for stepcount
        let healthStepType = HKQuantityType(.stepCount)
        let sampleDateRange = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sample = HKSamplePredicate.quantitySample(type: healthStepType, predicate: sampleDateRange)
        
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: sample, options: .mostRecent, anchorDate: Date(), intervalComponents: DateComponents(second:1))

        let stepsData = try await stepsQuery.result(for: healthStore)
        
        // Sum the number of steps in each time period and store in the cumulative steps variable
        var cumulativeStepsHealthKit = 0.0
        stepsData.enumerateStatistics(from: startDate, to: endDate)
        {
            statistics, pointer in
            let stepCount = statistics.sumQuantity()?.doubleValue(for: .count())
            if let stepCount, stepCount > 0 {
                cumulativeStepsHealthKit += stepCount
                DispatchQueue.main.async {
                    //set the latestSteps
                    self.latestSteps = Int(stepCount)
                }
            }
            
        }
        
        //capture the value so we can use it in the dispatch queue (I was getting an error without this related to concurrency issues I think)
        let capturedSteps = cumulativeStepsHealthKit
        DispatchQueue.main.async {
            self.hkSteps = capturedSteps
            print("\(capturedSteps) steps \(startDate) to \(endDate)")
            self.stepEvent(capturedSteps, 0.0, self.pedometerSteps)
        }
    }
    
    // dispatch event when steps are added
    func stepEvent(_ prevSteps : Double, _ newSteps : Double, _ pedSteps : Double) {
        if prevSteps > 0 || pedSteps > 0 || newSteps > 0 {
            if self.hkSteps + pedSteps >= self.stepGoal {
                //we made it to the step goal...
                self.startTime = Date.now.zeroSeconds!.addingTimeInterval(TimeInterval(60))
                self.hkSteps = 0
                self.pedometerSteps = 0
                self.stepGoal *= 1.2 // temporary
                self.restartPedometer()
            }
        }
    }
    
    func getTotalSteps() -> Double {
        return self.hkSteps + self.pedometerSteps
    }
    
}
