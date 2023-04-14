//
//  TrainingDetailsModelTests.swift
//  TabataAppTests
//
//  Created by Kirill Ushkov on 14.04.2023.
//

import XCTest
@testable import Models

final class TrainingDetailsModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserActions() {
        let model = TrainingDetailModel(training: .mock)
        model.editTapped()
        XCTAssertNotNil(model.destination)
        XCTAssertEqual(model.destination, .edit(TrainingFormModel(training: .mock)))
        
        model.cancelEditingTapped()
        XCTAssertNil(model.destination)
            
        let saved: Training = .empty
        model.saveTapped(saved)
        XCTAssertEqual(model.training, saved)
        XCTAssertNil(model.destination)
    }
}
