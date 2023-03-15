import SwiftUI
import Combine

final class TrainingFormModel: ObservableObject, Hashable {
    static func == (lhs: TrainingFormModel, rhs: TrainingFormModel) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    @Published var training: Training
    
    init(training: Training) {
        self.training = training
    }
    
    func addLap() {
        let defaultLap = Training.Lap(breakDuration: 60, workDuration: 30)
        self.training.laps.append(defaultLap)
    }
    
    func removeLap(_ lap: Training.Lap) {
        self.training.laps.removeAll { $0.id == lap.id }
    }
}
