//
//  TrainingTimer.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 13.03.2023.
//

import Foundation
import SwiftUI

class TrainingLaunchModel: ObservableObject {
    private var phases: [Phase]
    private(set) var currentDuration: Int = 0
    private var currentIndex = 0
    let totalDuration: Int
    private let training: Training
    
    private enum Phase {
        case breakBetweenLaps(Int)
        case lapWork(Int, Int)
        case lapBreak(Int, Int)
    }
    
    init(training: Training) {
        self.phases = []
        self.training = training
        self.totalDuration = training.totalDuration
        
        for (index, lap) in training.laps.enumerated() {
            self.phases.append(.breakBetweenLaps(training.breakBetweenLaps))
            self.phases.append(.lapWork(index, lap.workDuration))
            self.phases.append(.lapBreak(index, lap.breakDuration))
        }
            
        self.setPhaseDuration()
    }
    
    func updatePhase() {
        currentIndex += 1
        setPhaseDuration()
    }
    
    var currentPhaseTitle: String {
        guard self.phases.count > 0 else { return "" }
        switch self.phases[self.currentIndex] {
        case .breakBetweenLaps:
            return "Break Between Laps"
        case let .lapWork(index, _):
            return "Lap \(index + 1): Working!"
        case let .lapBreak(index, _):
            return "Lap \(index + 1): Let's have a rest!"
        }
    }
    
    private func setPhaseDuration() {
        guard self.phases.count > 0 else { return }
        switch self.phases[self.currentIndex] {
        case let .breakBetweenLaps(duration):
            self.currentDuration = duration
        case let .lapWork(_, duration):
            self.currentDuration = duration
        case let .lapBreak(_, duration):
            self.currentDuration = duration
        }
    }
}
