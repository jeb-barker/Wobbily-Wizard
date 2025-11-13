//
//  StepManager.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/29/25.
//


import SwiftUI
import HealthKit
import CoreMotion

class StepManager {
    private let pedometer = CMPedometer()

    private var healthStore: HKHealthStore?
    private var error: Error?
    //Step Variables
    private var hkSteps: Double = 0.0
    public var stepGoal : Double = 300.0
    public var latestSteps : Int = 0
    public var pedometerSteps : Double = 0 // TODO: make private after testing
    public var storedSteps : Double = 0
    //Timing Variables
    private var startTime : Date = Date.now
    private var stepTimer : Timer? = nil
    private var pedometerTimer : Timer? = nil
    private var timerRuns : Int = 0
    
    init (_ initialSteps : Double?) {
        //initialize storedSteps to either 0 or the value passed in when the model is decoded.
        storedSteps = initialSteps ?? 0
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
        startPedometer()
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
    
    func startPedometer() {
        // Ensure pedometer is available
        guard CMPedometer.isPedometerEventTrackingAvailable() else {
            print("Pedometer event tracking not available.")
            return
        }
        self.pedometerSteps = 0
        //reset the pedometer
        pedometer.stopUpdates()
        pedometer.startUpdates(from: Date()) { [weak self] (pedometerData, error) in
            DispatchQueue.main.async {
                if let pedometerData = pedometerData {
                    //print("Pedometer event \(pedometerData)")
                    let prevSteps = self?.pedometerSteps
                    //change the previousSteps var if new steps are detected
                    if let prevSteps = prevSteps, prevSteps > 0 {
                        self?.latestSteps = Int(pedometerData.numberOfSteps.doubleValue - prevSteps)
                    }
                    self?.pedometerSteps = pedometerData.numberOfSteps.doubleValue
                } else if let error = error {
                    print("Pedometer error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // Fetch steps from startTime to the start of the current minute
    // Used for debug purposes when running in a simulator / speeding up debugging to quickly add steps
    func fetchCumulativeSteps() async {
        
        // make sure healthStore is initialized
        guard let healthStore else { return }

        let startDate = startTime.zeroSeconds!.addingTimeInterval(TimeInterval(-1))
        let endDate = Date.now.zeroSeconds!.addingTimeInterval(60)
        
        //debug
        //print("getting steps from \(startDate) to \(endDate)")
        
        // only query for stepcount
        let healthStepType = HKQuantityType(.stepCount)
        let sampleDateRange = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sample = HKSamplePredicate.quantitySample(type: healthStepType, predicate: sampleDateRange)
        
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: sample, options: .mostRecent, anchorDate: Date(), intervalComponents: DateComponents(second:1))
        
        
        do {
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
                        //set the latestSteps. not super necessary
                        self.latestSteps = Int(stepCount)
                    }
                }
                
                //capture the value so we can use it in the dispatch queue (I was getting an error without this related to concurrency issues I think)
                let capturedSteps = cumulativeStepsHealthKit
                self.pedometerSteps = capturedSteps
                print("\(capturedSteps) steps \(startDate) to \(endDate)")
                // line below will reset the stepManager if the goal has been met
                //self.resetManager(capturedSteps, 0.0, self.pedometerSteps)
            }
        }
        catch {
            print("An error occurred: \(error)")
            return
        }
    }
    
    // reset the manager (if goal has been met)
    func resetManager(_ prevSteps : Double, _ newSteps : Double, _ pedSteps : Double) {
        if prevSteps > 0 || pedSteps > 0 || newSteps > 0 {
            if self.hkSteps + self.pedometerSteps + self.storedSteps >= self.stepGoal {
                //we made it to the step goal...
                self.startTime = Date.now.zeroSeconds!.addingTimeInterval(TimeInterval(-1))
                self.pedometerSteps = 0
                self.stepGoal *= 1.2 // TODO: change dynamically from database?
                self.storedSteps = 0
                self.latestSteps = 0
                self.hkSteps = 0
                //restart the pedometer
                self.startPedometer()
            }
        }
    }
    
    func getTotalSteps() -> Double {
        return self.pedometerSteps + self.storedSteps
    }
}
