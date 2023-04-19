//
//  Utilities.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 15.04.2023.
//

import Foundation
import Models

func formatDuration(_ duration: Int) -> String {
    return Duration.seconds(duration).formatted()
}

extension TrainingLaunchModel {
    static var forPreview: TrainingLaunchModel {
        TrainingLaunchModel(training:
                                Training(title: "First Training",
                                         laps: [
                                            Training.Lap(phases: [
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 0"),
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 0")
                                            ]),
                                            Training.Lap(phases: [
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 1"),
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 1")
                                            ])
                                         ],
                                         breakBetweenLaps: 60))
    }
}

extension Training {
    static var forPreview: Self {
        return Training(title: "First Training",
                        laps: [
                            Training.Lap(phases: [
                                Phase(breakDuration: 5, workDuration: 5, title: "Section 0"),
                                Phase(breakDuration: 5, workDuration: 5, title: "Section 0")
                            ]),
                            
                            Training.Lap(phases: [
                                Phase(breakDuration: 5, workDuration: 5, title: "Section 1"),
                                Phase(breakDuration: 5, workDuration: 5, title: "Section 1")
                            ])
                        ],
                        breakBetweenLaps: 5)
    }
}

extension DataManager where T == [Training] {
    static var forPreview: DataManager {
        DataManager(write: { _, _ in
            return Result.success(())
        }, read: { url in
            return Result.success([.forPreview, .forPreview, .forPreview, .forPreview])
        })
    }
}

extension TrainingsListModel {
    static var forPreview: TrainingsListModel {
        TrainingsListModel(dataManager: .forPreview)
    }
}

extension TrainingPhasesModel {
    public var currentPhaseTitle: String {
        guard self.phases.count > 0 else { return "" }
        switch self.phases[self.currentIndex] {
        case .breakBetweenLaps:
            return L10n.breakBetweenLaps
        case let .lapWork(index, _, title):
            return "\(L10n.lap) \(index): \(title)"
        case let .lapBreak(index, _):
            return "\(L10n.lap) \(index): \(L10n.break)!"
        }
    }
}
