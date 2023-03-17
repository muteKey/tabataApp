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
    private var currentIndex = -1 {
        didSet {
            print(self.phases[currentIndex])
        }
    }
    let totalDuration: Int
    
    private enum Phase {
        case breakBetweenLaps(Int)
        case lapWork(lapNumber: Int, duration: Int, title: String)
        case lapBreak(lapNumber: Int, duration: Int)
    }
    
    init(training: Training) {
        self.phases = []
        self.totalDuration = training.totalDuration
        
        for i in 0..<training.laps.count {
            self.phases.append(.breakBetweenLaps(training.breakBetweenLaps))
            for j in 0..<training.laps[i].phases.count {
                self.phases.append(.lapWork(lapNumber: i + 1, duration: training.laps[i].phases[j].workDuration, title: training.laps[i].phases[j].title))
                self.phases.append(.lapBreak(lapNumber: i + 1, duration: training.laps[i].phases[j].breakDuration))
            }
        }            
        updatePhase()
    }
    
    func updatePhase() {
        guard currentIndex < self.phases.count - 1 else { return }
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
        case let .lapWork(index, _, title):
            return "Lap \(index): \(title)"
        case let .lapBreak(index, _):
            return "Lap \(index): Break!"
        }
    }
    
    private func setPhaseDuration() {
        guard self.phases.count > 0 else { return }
        switch self.phases[self.currentIndex] {
        case let .breakBetweenLaps(duration):
            self.currentDuration = duration
        case let .lapWork(_, duration, _):
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
