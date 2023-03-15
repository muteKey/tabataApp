//
//  TrainingTimer.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 13.03.2023.
//

import Foundation
import SwiftUI

final class TrainingPhasesModel {
    private var phases: [Phase]
    private(set) var currentDuration: Int = 0
    private var currentIndex = 0
    let totalDuration: Int
    
    private enum Phase {
        case breakBetweenLaps(Int)
        case lapWork(Int, Int)
        case lapBreak(Int, Int)
    }
    
    init(training: Training) {
        self.phases = []
        self.totalDuration = training.totalDuration
        
        for (index, lap) in training.laps.enumerated() {
            self.phases.append(.breakBetweenLaps(training.breakBetweenLaps))
            self.phases.append(.lapWork(index, lap.workDuration))
            self.phases.append(.lapBreak(index, lap.breakDuration))
        }
            
        setPhaseDuration()
    }
    
    func updatePhase() {
        currentIndex += 1
        setPhaseDuration()
    }
    
    var color: Color {
        guard self.phases.count > 0 else { return .black }
        switch self.phases[self.currentIndex] {
        case .breakBetweenLaps:
            return .gray
        case .lapWork:
            return .red
        case .lapBreak:
            return .blue
        }
    }
    
    var currentPhaseTitle: String {
        guard self.phases.count > 0 else { return "" }
        switch self.phases[self.currentIndex] {
        case .breakBetweenLaps:
            return "Break Between Laps"
        case let .lapWork(index, _):
            return "Lap \(index + 1): Working!"
        case let .lapBreak(index, _):
            return "Lap \(index + 1): Break!"
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

final class TrainingLaunchModel: ObservableObject, Hashable {
    static func == (lhs: TrainingLaunchModel, rhs: TrainingLaunchModel) -> Bool {
        rhs === lhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    let phasesModel: TrainingPhasesModel
    var onStop: () -> Void = {}
    var onFinish: () -> Void = {}
    let training: Training
    
    init(training: Training) {
        self.phasesModel = TrainingPhasesModel(training: training)
        self.training = training
    }
    
}
