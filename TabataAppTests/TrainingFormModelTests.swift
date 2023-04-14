//
//  TrainingFormModelTests.swift
//  TabataAppTests
//
//  Created by Kirill Ushkov on 14.04.2023.
//

import XCTest

@testable import Models

final class TrainingFormModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLaps() {
        let training: Training = .empty
        let model = TrainingFormModel(training: training)
        
        let defaultLap = Training.Lap(phases: [])
        model.addLap(defaultLap)
        model.addLap(defaultLap)
        model.addLap(defaultLap)
        XCTAssertTrue(model.training.laps.count == 3)
        
        let lapNotInTraining = Training.Lap(phases: [])
        model.removeLap(lapNotInTraining)
        XCTAssertTrue(model.training.laps.count == 3)
    }
    
    func testPhases() {
        let training: Training = .empty
        let model = TrainingFormModel(training: training)

        let defaultPhase = Training.Phase.default
        let defaultLap = Training.Lap(phases: [defaultPhase])
        model.addLap(defaultLap)
        XCTAssertTrue(model.training.laps[0].phases.count == 1)
        
        let newPhase = Training.Phase.init(breakDuration: 60, workDuration: 60, title: "Test Phase")
        model.addPhase(newPhase, for: defaultLap)
        XCTAssertTrue(model.training.laps[0].phases.count == 2)
        
        let lapNotInTraining = Training.Lap(phases: [])
        model.addPhase(defaultPhase, for: lapNotInTraining)
        XCTAssertTrue(model.training.laps[0].phases.count == 2)
        
        model.removePhase(defaultPhase, from: defaultLap)
        XCTAssertTrue(model.training.laps[0].phases.count == 1)
        
        model.removePhase(newPhase, from: defaultLap)
        XCTAssertTrue(model.training.laps.count == 0)
        
        model.addLap(defaultLap)
        model.addPhase(defaultPhase, for: defaultLap)
        model.addPhase(defaultPhase, for: defaultLap)
        model.removePhase(defaultPhase, from: defaultLap)
        XCTAssertTrue(model.training.laps.count == 0)
    }
}
