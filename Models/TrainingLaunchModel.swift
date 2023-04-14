//
//  TrainingTimer.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 13.03.2023.
//

import Foundation
import SwiftUI

public final class TrainingPhasesModel {
    public private(set) var phases: [Phase]
    public private(set) var currentDuration: Int = 0
    public private(set) var currentIndex = -1
    public let totalDuration: Int
    
    public enum Phase: Equatable {
        case breakBetweenLaps(Int)
        case lapWork(lapNumber: Int, duration: Int, title: String)
        case lapBreak(lapNumber: Int, duration: Int)
    }
    
    public init(training: Training) {
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
    
    public func updatePhase() {
        guard currentIndex < self.phases.count - 1 else { return }
        currentIndex += 1
        setPhaseDuration()
    }
        
    public var color: Color {
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

public final class TrainingLaunchModel: ObservableObject, Hashable {
    public static func == (lhs: TrainingLaunchModel, rhs: TrainingLaunchModel) -> Bool {
        rhs === lhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public let phasesModel: TrainingPhasesModel
    public var onStop: () -> Void = {}
    public var onFinish: () -> Void = {}
    public let training: Training
    
    public init(training: Training) {
        self.phasesModel = TrainingPhasesModel(training: training)
        self.training = training
    }
}
