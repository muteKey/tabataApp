import SwiftUI
import Combine

final class TrainingFormModel: ObservableObject, Hashable {
    static func == (lhs: TrainingFormModel, rhs: TrainingFormModel) -> Bool {
        lhs === rhs
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    enum Content {
        case section(String, [Training.Phase])
    }
    
    @Published var training: Training
    
    
    init(training: Training) {
        self.training = training
    }
    
    func addLap() {
        withAnimation {
            let defaultLap = Training.Lap(phases: [Training.Phase(breakDuration: 5, workDuration: 10, title: "")])
            self.training.laps.append(defaultLap)
        }
    }
    
    func removeLap(_ lap: Training.Lap) {
        withAnimation {
            self.training.laps.removeAll { $0.id == lap.id }
        }
    }
    
    func addPhase(for lap: Training.Lap) {
        guard let lapIndex = training.laps.firstIndex(where: {$0.id == lap.id }) else { return }
        withAnimation {
            self.training.laps[lapIndex].phases.append(Training.Phase(breakDuration: 5, workDuration: 10, title: ""))
        }
    }
    
    func removePhase(_ phase: Training.Phase, from lap: Training.Lap) {
        guard let lapIndex = training.laps.firstIndex(where: {$0.id == lap.id }) else { return }
        withAnimation {
            training.laps[lapIndex].phases.removeAll(where: { $0.id == phase.id })
            
            if training.laps[lapIndex].phases.count == 0 {
                training.laps.remove(at: lapIndex)
            }
        }
    }
    
    func sectionTitle(for lap: Training.Lap) -> String {
        guard let index = training.laps.firstIndex(where: {$0.id == lap.id }) else { return "" }
        return "\(L10n.lap) \(index + 1)"
    }
    
    var breakBetweenLapsRange: ClosedRange<Int> {
        return 0...60
    }
    
    var workDurationRange: ClosedRange<Int> {
        return 0...45*60
    }
    
    var breakDurationRange: ClosedRange<Int> {
        return 0...30*60
    }
}
