//
//  TrainingsListTests.swift
//  TabataAppTests
//
//  Created by Kirill Ushkov on 12.04.2023.
//

import XCTest
@testable import Models

extension DataManager where T == [Training] {
    static var mock: DataManager {
        DataManager<[Training]> { (url, trainings: [Training]) in
            return Result.success(())
        } read: { url in
            return Result.success([])
        }
    }
    
    static var failableMock: DataManager {
        DataManager(write: { _, _ in
            return Result.success(())
        }, read: { _ in
            return Result.failure(NSError(domain: NSCocoaErrorDomain, code: NSURLErrorFileDoesNotExist))
        })
    }
    
    static var realWrite: DataManager {
        DataManager { url, trainings in
            if !FileManager.default.fileExists(atPath: url.path()) {
                FileManager.default.createFile(atPath: url.path(), contents: nil)
            }
            do {
                let data = try JSONEncoder().encode(trainings)
                try data.write(to: url)
                return Result.success(())
            } catch {
                return Result.failure(error)
            }
        } read: { _ in
            return Result.success([])
        }

    }
}

final class TrainingsListTests: XCTestCase {
    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: URL.testTrainingsLocation)
    }

    func testBasicOperations() {
        let list = TrainingsListModel(dataManager: .mock)
        XCTAssertEqual(list.trainings.count, 0)
        
        list.addTraining(.mock)
        XCTAssertEqual(list.trainings.count, 1)
        
        list.removeTraining(at: IndexSet(integer: 0))
        XCTAssertEqual(list.trainings.count, 0)
    }
    
    func testEmptyTrainings() {
        let list = TrainingsListModel(dataManager: .failableMock)
        XCTAssertEqual(list.trainings.count, 0)
    }
    
    func testUserActions() {
        let list = TrainingsListModel(dataManager: .mock)
        list.addTrainingTapped()
        
        XCTAssertNotNil(list.destination)
        XCTAssertEqual(list.destination, .add(TrainingFormModel(training: .empty)))
        
        list.saveTapped(.mock)
        XCTAssertNil(list.destination)
        XCTAssertEqual(list.trainings.count, 1)
    }
    
    func testSaveAction() {
        let list = TrainingsListModel(dataManager: .realWrite)
        list.addTraining(.mock)
        
        do {
            try list.save(at: .testTrainingsLocation)
            let data = try! Data.init(contentsOf: .testTrainingsLocation)
            XCTAssertFalse(data.isEmpty)
            let trainings = try! JSONDecoder().decode([Training].self, from: data)
            XCTAssertEqual(list.trainings, trainings)
        } catch {
            XCTFail("Test should not fail")
        }
    }
}
