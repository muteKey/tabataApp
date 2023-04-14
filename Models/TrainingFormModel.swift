import SwiftUI
import Combine

public final class TrainingFormModel: ObservableObject, Hashable {
    public static func == (lhs: TrainingFormModel, rhs: TrainingFormModel) -> Bool {
        lhs === rhs
    }
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    @Published public var training: Training
    
    public init(training: Training) {
        self.training = training
    }
    
    public func addLap(_ lap: Training.Lap) {
        self.training.laps.append(lap)
    }
    
    public func removeLap(_ lap: Training.Lap) {
        self.training.laps.removeAll { $0.id == lap.id }
    }
    
    public func addPhase(_ phase: Training.Phase = .default, for lap: Training.Lap) {
        guard let lapIndex = training.laps.firstIndex(where: {$0.id == lap.id }) else { return }
        self.training.laps[lapIndex].phases.append(phase)
    }
    
    public func removePhase(_ phase: Training.Phase, from lap: Training.Lap) {
        guard let lapIndex = training.laps.firstIndex(where: {$0.id == lap.id }) else { return }
        training.laps[lapIndex].phases.removeAll(where: { $0.id == phase.id })
        
        if training.laps[lapIndex].phases.count == 0 {
            training.laps.remove(at: lapIndex)
        }
    }
}
