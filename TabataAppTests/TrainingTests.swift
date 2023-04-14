//
//  TrainingTests.swift
//  TabataAppTests
//
//  Created by Kirill Ushkov on 14.04.2023.
//

import XCTest
@testable import Models

final class TrainingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPhaseValidity() {
        let validPhase = Training.Phase(breakDuration: 60, workDuration: 30, title: "Test phase")
        XCTAssertTrue(validPhase.isValid)
        
        let invalidPhase1 = Training.Phase(breakDuration: 0, workDuration: 30, title: "Test phase")
        XCTAssertFalse(invalidPhase1.isValid)
        
        let invalidPhase2 = Training.Phase(breakDuration: 30, workDuration: 0, title: "Test phase")
        XCTAssertFalse(invalidPhase2.isValid)
        
        let invalidPhase3 = Training.Phase(breakDuration: 30, workDuration: 30, title: "")
        XCTAssertFalse(invalidPhase3.isValid)
    }
    
    func testLapValidity() {
        let validPhase = Training.Phase(breakDuration: 60, workDuration: 30, title: "Test phase")
        let invalidPhase = Training.Phase(breakDuration: 0, workDuration: 30, title: "Test phase")

        let validLap = Training.Lap(phases: [validPhase])
        XCTAssertTrue(validLap.isValid)
        
        let invalidLap = Training.Lap(phases: [invalidPhase])
        XCTAssertFalse(invalidLap.isValid)
    }
    
    func testTrainingValidity() {
        let validPhase = Training.Phase(breakDuration: 60, workDuration: 30, title: "Test phase")
        let invalidPhase = Training.Phase(breakDuration: 0, workDuration: 30, title: "Test phase")
        let validLap = Training.Lap(phases: [validPhase])
        let invalidLap = Training.Lap(phases: [invalidPhase])

        let validTraining = Training(title: "Test Training", laps: [validLap], breakBetweenLaps: 10)
        XCTAssertTrue(validTraining.isValid)
        
        let invalidTraining1 = Training(title: "", laps: [validLap], breakBetweenLaps: 10)
        XCTAssertFalse(invalidTraining1.isValid)
        
        let invalidTraining2 = Training(title: "Test", laps: [invalidLap], breakBetweenLaps: 10)
        XCTAssertFalse(invalidTraining2.isValid)

        let invalidTraining3 = Training(title: "Test", laps: [validLap], breakBetweenLaps: 0)
        XCTAssertFalse(invalidTraining3.isValid)

        let invalidTraining4 = Training(title: "", laps: [invalidLap], breakBetweenLaps: 0)
        XCTAssertFalse(invalidTraining4.isValid)
    }
    
    func testTotalDuration() {
        let trainingWithOneLap = Training(title: "Test",
                                          laps: [
                                            Training.Lap(phases: [
                                                Training.Phase(breakDuration: 10, workDuration: 30, title: "Test1"),
                                                Training.Phase(breakDuration: 10, workDuration: 30, title: "Test2")
                                    ])
                                ],
                                breakBetweenLaps: 10)
        XCTAssertEqual(trainingWithOneLap.totalDuration, 90)
        
        let trainingWithMultipleLaps = Training(title: "Test2",
                                                laps: [
                                                    Training.Lap(phases: [
                                                        Training.Phase(breakDuration: 10, workDuration: 30, title: "Test1"),
                                                        Training.Phase(breakDuration: 10, workDuration: 30, title: "Test2")
                                                    ]),
                                                    Training.Lap(phases: [
                                                        Training.Phase(breakDuration: 20, workDuration: 60, title: "Test3"),
                                                        Training.Phase(breakDuration: 20, workDuration: 60, title: "Test4")
                                                    ]),
                                                    Training.Lap(phases: [
                                                        Training.Phase(breakDuration: 30, workDuration: 30, title: "Test5"),
                                                        Training.Phase(breakDuration: 30, workDuration: 30, title: "Test6")
                                                    ]),
                                                ],
                                                breakBetweenLaps: 15)
        XCTAssertEqual(trainingWithMultipleLaps.totalDuration, 405)
    }
}
