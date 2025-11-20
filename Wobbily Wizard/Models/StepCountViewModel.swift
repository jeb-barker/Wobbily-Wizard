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
final class StepCountViewModel: ObservableObject, Codable {
    // The steps to be displayed. Comes from the stepManager + storedSteps
    @Published var steps: Double = 0.0
    @Published var latestSteps : Int = 0
    @Published var stepGoal : Double = 300.0
    
    private var timer : Timer? = nil
    // manages steps taken in the current session
    private var stepManager : StepManager
    // stores steps from previous sessions (not )
    private var storedSteps : Double = 0.0
    
    init() {
        stepManager = StepManager(0)
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
    }
    
    func updateSteps() {
        DispatchQueue.main.async {
            //print("updating steps \(self.stepManager.getTotalSteps())")
            self.steps = self.stepManager.getTotalSteps()
            self.latestSteps = self.stepManager.latestSteps
        }
    }
    
    func fightOver(didPlayerWin : Bool) {
        
        self.stepManager.resetManager(1, 0, 0)
        if didPlayerWin {
            self.stepGoal *= 1.2 //TODO: Balance this
        }
        //make sure the step goals are aligned
        self.stepManager.stepGoal = self.stepGoal
        
    }
    
    func isFinished() -> Bool {
        return self.stepManager.getTotalSteps() >= stepGoal
    }
    
    func debugSteps() async {
        await self.stepManager.fetchCumulativeSteps()
    }
    
    // Codable (Encoding / Decoding)
    enum CodingKeys: String, CodingKey {
        case steps
        case stepGoal
    }
    
    // Path for saving data to device
    static private var saveURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("stepModel.json")
    }

    // Saving and loading the file
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            try? encoded.write(to: Self.saveURL)
        }
    }

    // Load from device if possible
    static func load() -> StepCountViewModel? {
        guard let data = try? Data(contentsOf: saveURL) else { return nil }
        return try? JSONDecoder().decode(StepCountViewModel.self, from: data)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //When we decode, we store the previous step count into storedSteps
        storedSteps = try container.decode(Double.self, forKey: .steps)
        stepGoal = try container.decode(Double.self, forKey: .stepGoal)
        
        // New instance of StepManager each time the model is instantiated
        self.stepManager = StepManager(storedSteps)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(steps, forKey: .steps)
        try container.encode(stepGoal, forKey: .stepGoal)
    }
    
}


