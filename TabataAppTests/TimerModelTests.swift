//
//  TimerModelTests.swift
//  TabataAppTests
//
//  Created by Kirill Ushkov on 14.04.2023.
//

import XCTest
@testable import Models

final class TimerModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBase() {
        let model = TimerModel()
        XCTAssertEqual(model.state, TimerModel.State.running)
        XCTAssertNotNil(model.cancellable)
        
        model.pauseTimer()
        XCTAssertNil(model.cancellable)
        XCTAssertEqual(model.state, TimerModel.State.paused)
        
        model.stopTimer()
        XCTAssertNil(model.cancellable)
        XCTAssertEqual(model.state, TimerModel.State.stopped)
    }

}
