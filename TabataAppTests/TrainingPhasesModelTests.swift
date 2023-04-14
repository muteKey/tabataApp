//
//  TrainingPhasesModelTests.swift
//  TabataAppTests
//
//  Created by Kirill Ushkov on 14.04.2023.
//

import XCTest
@testable import Models

final class TrainingPhasesModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
        let training: Training = .mock
        let model = TrainingPhasesModel(training: training)
        XCTAssertEqual(model.totalDuration, training.totalDuration)
        XCTAssertEqual(model.phases.count, 3)
        XCTAssertEqual(model.currentIndex, 0)
        XCTAssertEqual(model.currentDuration, training.breakBetweenLaps)
        XCTAssertEqual(model.color, .gray)
        XCTAssertEqual(model.phases, [
            .breakBetweenLaps(training.breakBetweenLaps),
            .lapWork(lapNumber: 1, duration: training.laps[0].phases[0].workDuration, title: training.laps[0].phases[0].title),
            .lapBreak(lapNumber: 1, duration: training.laps[0].phases[0].breakDuration)])
        
    }
    
    func testPhaseUpdates() {
        let training: Training = .mock
        let model = TrainingPhasesModel(training: training)

        model.updatePhase()
        XCTAssertEqual(model.currentDuration, training.laps[0].phases[0].workDuration)
        XCTAssertEqual(model.currentIndex, 1)
        XCTAssertEqual(model.color, .red)
        
        model.updatePhase()
        XCTAssertEqual(model.currentDuration, training.laps[0].phases[0].breakDuration)
        XCTAssertEqual(model.currentIndex, 2)
        XCTAssertEqual(model.color, .blue)
        
        model.updatePhase()
        XCTAssertEqual(model.currentIndex, 2)
    }
    
    func testCornerCase() {
        let training = Training.empty
        let model = TrainingPhasesModel(training: training)
        XCTAssertEqual(model.color, .black)
        XCTAssertEqual(model.currentIndex, -1)
        XCTAssertEqual(model.currentDuration, 0)
        
        model.updatePhase()
        XCTAssertEqual(model.color, .black)
        XCTAssertEqual(model.currentIndex, -1)
        XCTAssertEqual(model.currentDuration, 0)
    }
}
