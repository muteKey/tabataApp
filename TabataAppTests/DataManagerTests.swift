//
//  DataManagerTests.swift
//  TabataAppTests
//
//  Created by Kirill Ushkov on 12.04.2023.
//

import XCTest
import Combine
import Foundation
@testable import Models

extension URL {
    static var testTrainingsLocation: Self {
        Self.cachesDirectory.appending(component: "trainings.json")
    }
}

extension Training {
    static var mock: Self {
        return Training(title: "Running",
                        laps: [
                            Lap(phases: [
                                Training.Phase(breakDuration: 30, workDuration: 30, title: "Lap 1")
                            ])
                        ],
                        breakBetweenLaps: 60)
    }
}

final class DataManagerTests: XCTestCase {
    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: URL.testTrainingsLocation)
        try? FileManager.default.removeItem(at: URL.cachesDirectory.appending(component: "nonexisting.json"))
    }
    
    func testLoadDataSuccess() {
        let manager = DataManager<[Training]>.live
        let url = Bundle(for: type(of: self)).url(forResource: "testTrainings", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let expected = try! JSONDecoder().decode([Training].self, from: data)
        do {
            let result = try manager.read(url).get()
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail("Test should not fail")
        }
    }
    
    func testLoadDataFromNonExistentFile() {
        let manager = DataManager<[Training]>.live
        let url = URL.cachesDirectory.appending(component: "nonexisting.json")
        do {
            let result = try manager.read(url).get()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Test should not fail")
        }
    }
    
    func testSaveDataSuccess() {
        let manager = DataManager<[Training]>.live
        let url = URL.testTrainingsLocation
        let trainings = [Training.mock]

        _ = manager.write(url, trainings)
        let data = try! Data(contentsOf: url)
        let expected = try! JSONDecoder().decode([Training].self, from: data)

        XCTAssertEqual(trainings, expected)
    }
    
    func testSaveToNonExistingFile() {
        let manager = DataManager<[Training]>.live
        let url = URL.cachesDirectory.appending(component: "nonexisting.json")
        let trainings = [Training.mock]
        
        _ = manager.write(url, trainings)
        let data = try! Data(contentsOf: url)
        let expected = try! JSONDecoder().decode([Training].self, from: data)
        
        XCTAssertEqual(trainings, expected)
    }
}
